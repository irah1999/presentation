-- ============================================
-- MySQL Database Migration Script
-- From SQLite to MySQL for Presenton Application
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS presenton_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE presenton_db;

-- ============================================
-- Table: presentations
-- Stores presentation metadata and configuration
-- ============================================
CREATE TABLE IF NOT EXISTS presentations (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID for the presentation',
    content TEXT NOT NULL COMMENT 'Presentation content/description',
    n_slides INT NOT NULL COMMENT 'Number of slides in presentation',
    language VARCHAR(50) NOT NULL COMMENT 'Presentation language',
    title VARCHAR(500) DEFAULT NULL COMMENT 'Presentation title',
    file_paths JSON DEFAULT NULL COMMENT 'Array of file paths used in presentation',
    outlines JSON DEFAULT NULL COMMENT 'Presentation outline structure',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT 'Last update timestamp',
    layout JSON DEFAULT NULL COMMENT 'Layout configuration',
    structure JSON DEFAULT NULL COMMENT 'Presentation structure',
    instructions TEXT DEFAULT NULL COMMENT 'Generation instructions',
    tone VARCHAR(100) DEFAULT NULL COMMENT 'Presentation tone',
    verbosity VARCHAR(100) DEFAULT NULL COMMENT 'Content verbosity level',
    include_table_of_contents BOOLEAN DEFAULT FALSE COMMENT 'Include table of contents slide',
    include_title_slide BOOLEAN DEFAULT TRUE COMMENT 'Include title slide',
    web_search BOOLEAN DEFAULT FALSE COMMENT 'Enable web search for content',
    INDEX idx_created_at (created_at),
    INDEX idx_updated_at (updated_at)
) ENGINE=InnoDB COMMENT='Presentation metadata and configuration';

-- ============================================
-- Table: slides
-- Stores individual slide data for presentations
-- ============================================
CREATE TABLE IF NOT EXISTS slides (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID for the slide',
    presentation CHAR(36) NOT NULL COMMENT 'Foreign key to presentations table',
    layout_group VARCHAR(200) NOT NULL COMMENT 'Layout group identifier',
    layout VARCHAR(200) NOT NULL COMMENT 'Layout type',
    `index` INT NOT NULL COMMENT 'Slide order index',
    content JSON NOT NULL COMMENT 'Slide content data',
    html_content LONGTEXT DEFAULT NULL COMMENT 'HTML representation of slide',
    speaker_note TEXT DEFAULT NULL COMMENT 'Speaker notes for the slide',
    properties JSON DEFAULT NULL COMMENT 'Additional slide properties',
    INDEX idx_presentation (presentation),
    INDEX idx_presentation_index (presentation, `index`),
    FOREIGN KEY (presentation) REFERENCES presentations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Individual slide data';

-- ============================================
-- Table: keyvaluesqlmodel
-- Generic key-value storage
-- ============================================
CREATE TABLE IF NOT EXISTS keyvaluesqlmodel (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID for the key-value pair',
    `key` VARCHAR(500) NOT NULL COMMENT 'Key identifier',
    value JSON NOT NULL COMMENT 'Value data',
    INDEX idx_key (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Generic key-value storage';

-- ============================================
-- Table: imageasset
-- Stores image asset metadata
-- ============================================
CREATE TABLE IF NOT EXISTS imageasset (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID for the image asset',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    is_uploaded BOOLEAN DEFAULT FALSE COMMENT 'Whether image was uploaded by user',
    path VARCHAR(1000) NOT NULL COMMENT 'File path to the image',
    extras JSON DEFAULT NULL COMMENT 'Additional metadata',
    INDEX idx_created_at (created_at),
    INDEX idx_is_uploaded (is_uploaded)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Image asset metadata';

-- ============================================
-- Table: presentation_layout_codes
-- Stores custom layout code for presentations
-- ============================================
CREATE TABLE IF NOT EXISTS presentation_layout_codes (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Auto-increment ID',
    presentation CHAR(36) NOT NULL COMMENT 'UUID of the presentation',
    layout_id VARCHAR(200) NOT NULL COMMENT 'Unique identifier for the layout',
    layout_name VARCHAR(200) NOT NULL COMMENT 'Display name of the layout',
    layout_code LONGTEXT NOT NULL COMMENT 'TSX/React component code for the layout',
    fonts JSON DEFAULT NULL COMMENT 'Optional list of font links',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT 'Last update timestamp',
    INDEX idx_presentation (presentation),
    INDEX idx_layout_id (layout_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Custom layout code storage';

-- ============================================
-- Table: templates
-- Stores presentation templates
-- ============================================
CREATE TABLE IF NOT EXISTS templates (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID for the template (matches presentation_id)',
    name VARCHAR(500) NOT NULL COMMENT 'Human friendly template name',
    description TEXT DEFAULT NULL COMMENT 'Optional template description',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    INDEX idx_created_at (created_at),
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Presentation templates';

-- ============================================
-- Table: webhook_subscriptions
-- Stores webhook subscription information
-- ============================================
CREATE TABLE IF NOT EXISTS webhook_subscriptions (
    id VARCHAR(100) PRIMARY KEY COMMENT 'Webhook subscription ID',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    url VARCHAR(2000) NOT NULL COMMENT 'Webhook URL',
    secret VARCHAR(500) DEFAULT NULL COMMENT 'Webhook secret for verification',
    event VARCHAR(200) NOT NULL COMMENT 'Event type to trigger webhook',
    INDEX idx_event (event),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Webhook subscriptions';

-- ============================================
-- Table: async_presentation_generation_tasks
-- Tracks async presentation generation tasks
-- ============================================
CREATE TABLE IF NOT EXISTS async_presentation_generation_tasks (
    id VARCHAR(100) PRIMARY KEY COMMENT 'Task ID',
    status VARCHAR(50) NOT NULL COMMENT 'Task status (pending, processing, completed, failed)',
    message TEXT DEFAULT NULL COMMENT 'Status message',
    error JSON DEFAULT NULL COMMENT 'Error details if failed',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT 'Last update timestamp',
    data JSON DEFAULT NULL COMMENT 'Task data and results',
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_updated_at (updated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Async presentation generation tasks';

-- ============================================
-- Table: ollamapullstatus (Container DB - Optional)
-- Tracks Ollama model pull status
-- ============================================
CREATE TABLE IF NOT EXISTS ollamapullstatus (
    id CHAR(36) PRIMARY KEY COMMENT 'UUID for the pull status',
    model VARCHAR(200) NOT NULL COMMENT 'Ollama model name',
    status VARCHAR(50) NOT NULL COMMENT 'Pull status',
    progress FLOAT DEFAULT 0 COMMENT 'Download progress percentage',
    created_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) COMMENT 'Creation timestamp',
    updated_at TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) COMMENT 'Last update timestamp',
    INDEX idx_model (model),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ollama model pull status';

-- ============================================
-- Summary of Tables and Their Purposes
-- ============================================
-- 1. presentations: Main presentation metadata
-- 2. slides: Individual slides within presentations
-- 3. keyvaluesqlmodel: Generic key-value storage
-- 4. imageasset: Image asset metadata
-- 5. presentation_layout_codes: Custom layout code
-- 6. templates: Presentation templates
-- 7. webhook_subscriptions: Webhook configurations
-- 8. async_presentation_generation_tasks: Async task tracking
-- 9. ollamapullstatus: Ollama model download tracking (optional)

-- ============================================
-- Verification Queries
-- ============================================
-- Show all tables
-- SHOW TABLES;

-- Show table structures
-- DESCRIBE presentations;
-- DESCRIBE slides;
-- DESCRIBE keyvaluesqlmodel;
-- DESCRIBE imageasset;
-- DESCRIBE presentation_layout_codes;
-- DESCRIBE templates;
-- DESCRIBE webhook_subscriptions;
-- DESCRIBE async_presentation_generation_tasks;
-- DESCRIBE ollamapullstatus;

-- Check table counts
-- SELECT 'presentations' as table_name, COUNT(*) as row_count FROM presentations
-- UNION ALL SELECT 'slides', COUNT(*) FROM slides
-- UNION ALL SELECT 'keyvaluesqlmodel', COUNT(*) FROM keyvaluesqlmodel
-- UNION ALL SELECT 'imageasset', COUNT(*) FROM imageasset
-- UNION ALL SELECT 'presentation_layout_codes', COUNT(*) FROM presentation_layout_codes
-- UNION ALL SELECT 'templates', COUNT(*) FROM templates
-- UNION ALL SELECT 'webhook_subscriptions', COUNT(*) FROM webhook_subscriptions
-- UNION ALL SELECT 'async_presentation_generation_tasks', COUNT(*) FROM async_presentation_generation_tasks;

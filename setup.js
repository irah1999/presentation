#!/usr/bin/env node

/**
 * Setup script for Next.js Presenton
 * This script helps you set up the project for the first time
 */

import { execSync } from 'child_process';
import { existsSync, copyFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

console.log('🚀 Setting up Next.js Presenton...\n');

// Step 1: Install dependencies
console.log('📦 Installing dependencies...');
try {
    execSync('npm install', { stdio: 'inherit', cwd: __dirname });
    console.log('✅ Dependencies installed\n');
} catch (error) {
    console.error('❌ Failed to install dependencies');
    process.exit(1);
}

// Step 2: Copy .env.example to .env if it doesn't exist
const envPath = join(__dirname, '.env');
const envExamplePath = join(__dirname, '.env.example');

if (!existsSync(envPath) && existsSync(envExamplePath)) {
    console.log('📝 Creating .env file from .env.example...');
    copyFileSync(envExamplePath, envPath);
    console.log('✅ .env file created\n');
    console.log('⚠️  Please edit .env and add your API keys\n');
} else if (existsSync(envPath)) {
    console.log('ℹ️  .env file already exists\n');
}

// Step 3: Generate Prisma client
console.log('🗄️  Generating Prisma client...');
try {
    execSync('npx prisma generate', { stdio: 'inherit', cwd: __dirname });
    console.log('✅ Prisma client generated\n');
} catch (error) {
    console.error('❌ Failed to generate Prisma client');
    process.exit(1);
}

// Step 4: Push database schema
console.log('🗄️  Creating database...');
try {
    execSync('npx prisma db push', { stdio: 'inherit', cwd: __dirname });
    console.log('✅ Database created\n');
} catch (error) {
    console.error('❌ Failed to create database');
    process.exit(1);
}

console.log('✨ Setup complete!\n');
console.log('Next steps:');
console.log('1. Edit .env and add your API keys');
console.log('2. Run: npm run dev');
console.log('3. Open: http://localhost:3000\n');

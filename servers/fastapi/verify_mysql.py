"""
MySQL Database Connection Verification Script
This script checks if MySQL database is accessible and creates tables if needed.
"""
import asyncio
import sys
from sqlalchemy import text
from services.database import sql_engine, create_db_and_tables


async def verify_mysql_connection():
    """Verify MySQL database connection and setup"""
    print("=" * 60)
    print("MySQL Database Connection Verification")
    print("=" * 60)
    
    try:
        # Test database connection
        print("\n1. Testing database connection...")
        async with sql_engine.connect() as conn:
            result = await conn.execute(text("SELECT 1"))
            result.fetchone()
        print("   ✅ Database connection successful!")
        
        # Get database info
        print("\n2. Getting database information...")
        async with sql_engine.connect() as conn:
            # Get database name
            result = await conn.execute(text("SELECT DATABASE()"))
            db_name = result.fetchone()[0]
            print(f"   📊 Connected to database: {db_name}")
            
            # Get MySQL version
            result = await conn.execute(text("SELECT VERSION()"))
            version = result.fetchone()[0]
            print(f"   🔧 MySQL version: {version}")
            
            # Get character set
            result = await conn.execute(text("SELECT @@character_set_database"))
            charset = result.fetchone()[0]
            print(f"   📝 Character set: {charset}")
            
        # Create tables if they don't exist
        print("\n3. Creating database tables...")
        await create_db_and_tables()
        print("   ✅ All tables created successfully!")
        
        # Verify tables were created
        print("\n4. Verifying tables...")
        async with sql_engine.connect() as conn:
            result = await conn.execute(text("SHOW TABLES"))
            tables = [row[0] for row in result.fetchall()]
            
            expected_tables = [
                'presentations',
                'slides',
                'keyvaluesqlmodel',
                'imageasset',
                'presentation_layout_codes',
                'templates',
                'webhook_subscriptions',
                'async_presentation_generation_tasks'
            ]
            
            print(f"   📋 Found {len(tables)} tables:")
            for table in tables:
                status = "✅" if table in expected_tables else "⚠️"
                print(f"      {status} {table}")
        
        # Test a simple query
        print("\n5. Testing database operations...")
        async with sql_engine.connect() as conn:
            result = await conn.execute(
                text("SELECT COUNT(*) FROM presentations")
            )
            count = result.fetchone()[0]
            print(f"   📊 Presentations in database: {count}")
        
        print("\n" + "=" * 60)
        print("✅ MySQL Database is ready for use!")
        print("=" * 60)
        print("\nYou can now start the application:")
        print("  python -m uvicorn server:app --reload --port 8000")
        print("=" * 60)
        
        return True
        
    except Exception as e:
        print("\n" + "=" * 60)
        print("❌ Database Connection Failed!")
        print("=" * 60)
        print(f"\nError: {str(e)}")
        print("\nTroubleshooting steps:")
        print("1. Verify MySQL is running:")
        print("   Get-Service -Name MySQL*")
        print("\n2. Check database exists:")
        print("   mysql -u root -p")
        print("   SHOW DATABASES;")
        print("\n3. Create database if needed:")
        print("   CREATE DATABASE presenton_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;")
        print("\n4. Verify connection string in utils/db_utils.py:")
        print("   mysql://root:root@localhost:3306/presenton_db")
        print("=" * 60)
        
        return False


async def main():
    """Main function"""
    success = await verify_mysql_connection()
    
    # Close engine
    await sql_engine.dispose()
    
    # Exit with appropriate code
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    asyncio.run(main())

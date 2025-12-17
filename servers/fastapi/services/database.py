from collections.abc import AsyncGenerator
import os
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    create_async_engine,
    async_sessionmaker,
    AsyncSession,
)
from sqlmodel import SQLModel

from models.sql.async_presentation_generation_status import (
    AsyncPresentationGenerationTaskModel,
)
from models.sql.image_asset import ImageAsset
from models.sql.key_value import KeyValueSqlModel
from models.sql.ollama_pull_status import OllamaPullStatus
from models.sql.presentation import PresentationModel
from models.sql.slide import SlideModel
from models.sql.presentation_layout_code import PresentationLayoutCodeModel
from models.sql.template import TemplateModel
from models.sql.webhook_subscription import WebhookSubscription
from utils.db_utils import get_database_url_and_connect_args


database_url, connect_args = get_database_url_and_connect_args()

# Create async engine with MySQL-optimized settings
engine_kwargs = {
    "connect_args": connect_args,
    "echo": False,  # Set to True for SQL query logging during development
}

# Add MySQL-specific pool settings for production
if "mysql" in database_url:
    engine_kwargs.update({
        "pool_size": 20,  # Number of connections to maintain
        "max_overflow": 10,  # Additional connections when pool is full
        "pool_timeout": 30,  # Seconds to wait for connection from pool
        "pool_recycle": 3600,  # Recycle connections after 1 hour
        "pool_pre_ping": True,  # Verify connection health before using
    })

sql_engine: AsyncEngine = create_async_engine(database_url, **engine_kwargs)
async_session_maker = async_sessionmaker(sql_engine, expire_on_commit=False)


async def get_async_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_maker() as session:
        yield session


# Container DB (Lives inside the container)
# container_db_url = "sqlite+aiosqlite:////app/container.db"
from utils.get_env import get_app_data_directory_env
container_db_path = os.path.join(get_app_data_directory_env() or ".", "container.db")
container_db_url = f"sqlite+aiosqlite:///{container_db_path}"

container_db_engine: AsyncEngine = create_async_engine(
    container_db_url, connect_args={"check_same_thread": False}
)
container_db_async_session_maker = async_sessionmaker(
    container_db_engine, expire_on_commit=False
)


async def get_container_db_async_session() -> AsyncGenerator[AsyncSession, None]:
    async with container_db_async_session_maker() as session:
        yield session


# Create Database and Tables
async def create_db_and_tables():
    async with sql_engine.begin() as conn:
        await conn.run_sync(
            lambda sync_conn: SQLModel.metadata.create_all(
                sync_conn,
                tables=[
                    PresentationModel.__table__,
                    SlideModel.__table__,
                    KeyValueSqlModel.__table__,
                    ImageAsset.__table__,
                    PresentationLayoutCodeModel.__table__,
                    TemplateModel.__table__,
                    WebhookSubscription.__table__,
                    AsyncPresentationGenerationTaskModel.__table__,
                ],
            )
        )

    async with container_db_engine.begin() as conn:
        await conn.run_sync(
            lambda sync_conn: SQLModel.metadata.create_all(
                sync_conn,
                tables=[OllamaPullStatus.__table__],
            )
        )

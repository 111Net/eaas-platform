from sqlalchemy import Column, Integer, String, ForeignKey
from app.models.base.base import Base

class Client(Base):
    __tablename__ = "clients"

    id = Column(Integer, primary_key=True, index=True)
    client_code = Column(String, unique=True, index=True)

    full_name = Column(String)
    email = Column(String)
    phone = Column(String)
    device_type = Column(String)

    provider_id = Column(Integer, ForeignKey("providers.id"))
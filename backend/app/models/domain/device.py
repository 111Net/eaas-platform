from sqlalchemy import Column, Integer, String
from app.models.base.base import Base

class Device(Base):
    __tablename__ = "devices"

    id = Column(Integer, primary_key=True, index=True)
    device_code = Column(String, unique=True, index=True)

    device_type = Column(String)
    manufacturer = Column(String)
    connectivity = Column(String)
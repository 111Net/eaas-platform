from sqlalchemy import Column, Integer, Float, String, DateTime, ForeignKey
from datetime import datetime
from app.models.base.base import Base

class EnergyUsage(Base):
    __tablename__ = "energy_usage"

    id = Column(Integer, primary_key=True, index=True)

    user = Column(String, index=True)
    provider_id = Column(Integer, ForeignKey("providers.id"))

    kwh = Column(Float)
    cost = Column(Float)

    timestamp = Column(DateTime, default=datetime.utcnow)
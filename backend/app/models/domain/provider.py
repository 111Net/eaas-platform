from sqlalchemy import Column, Integer, String
from app.models.base.base import Base

class Provider(Base):
    __tablename__ = "providers"

    id = Column(Integer, primary_key=True, index=True)
    provider_code = Column(String, unique=True, index=True)

    company_name = Column(String)
    contact_person = Column(String)
    email = Column(String, unique=True, index=True)
    phone = Column(String)
    service_type = Column(String)
"""Module for mocking serial socket monitoring related"""

import base64
from typing import Any, Optional, Generic, TypeVar, Union
from result import Result
from dataclasses import dataclass

SERIALIZABLE = TypeVar('SERIALIZABLE')
PI = TypeVar('PI')
PO = TypeVar('PO')


class Socketlike(Generic[SERIALIZABLE, PI, PO]):
    """Interface for interactions w/ sockets"""
    async def connect(self) -> Optional[Exception]:
        pass

    async def disconnect(self) -> Optional[Exception]:
        pass

    async def rx(self) -> Result[PI, Exception]:
        pass

    async def tx(self, data: PO) -> Optional[Exception]:
        pass


@dataclass(frozen=True, eq=False)
class MonitorUnavailable:
    """Message regarding hardware monitor unavailability"""
    reason: str


@dataclass(frozen=True, eq=False)
class SerialMonitorMessageToClient:
    """Message from hardware serial monitor to client"""
    base64Bytes: str

    @staticmethod
    def from_bytes(content: bytes):
        """Construct message from bytes"""
        return SerialMonitorMessageToClient(base64.b64encode(content).decode("utf-8"))

    def to_bytes(self) -> bytes:
        """Construct bytes from message"""
        return base64.b64decode(self.base64Bytes)


@dataclass(frozen=True, eq=False)
class SerialMonitorMessageToAgent:
    """Message from client to hardware serial monitor"""
    base64Bytes: str

    def __eq__(self, other) -> bool:
        return self.base64Bytes == other.base64Bytes

    @staticmethod
    def from_bytes(content: bytes):
        """Construct message from bytes"""
        return SerialMonitorMessageToAgent(base64.b64encode(content).decode("utf-8"))

    def to_bytes(self):
        """Construct bytes from message"""
        return base64.b64decode(self.base64Bytes)


MonitorListenerIncomingMessage = Union[MonitorUnavailable, SerialMonitorMessageToClient]
MonitorListenerOutgoingMessage = Union[SerialMonitorMessageToAgent]


class MonitorSerialHelperLike:
    """Helper for managing monitor messages"""

    @staticmethod
    def isMonitorUnavailable(message: Any) -> bool:
        """Check if message is of type 'MonitorUnavailable'"""
        pass

    @staticmethod
    def isSerialMonitorMessageToClient(message: Any) -> bool:
        """Check if message is of type 'SerialMonitorMessageToClient'"""
        pass

    @staticmethod
    def isCodecParseException(instance: Any) -> bool:
        """Check if class instance is of type 'CodecParseException'"""
        pass

    @staticmethod
    def createSerialMonitorMessageToAgent(payload: bytes) -> Any:
        """Create createSerialMonitorMessageToAgent from bytes"""
        pass


class MonitorSerial:
    """Interface for serial socket monitors"""

    helper: MonitorSerialHelperLike

    def __init__(self, helper):
        self.helper = helper

    async def run(
        self,
        socketlike: Socketlike[Any, MonitorListenerIncomingMessage, MonitorListenerOutgoingMessage]
    ):
        """Receive serial monitor websocket messages & implement user interfacing"""
        pass


class CodecParseException(Exception):
    """Exception thrown by failing decoders"""
    def __eq__(self, other) -> bool:
        return str(self) == str(other)

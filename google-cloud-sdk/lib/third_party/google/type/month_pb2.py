# -*- coding: utf-8 -*-

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/type/month.proto
"""Generated protocol buffer code."""
from cloudsdk.google.protobuf.internal import enum_type_wrapper
from cloudsdk.google.protobuf import descriptor as _descriptor
from cloudsdk.google.protobuf import message as _message
from cloudsdk.google.protobuf import reflection as _reflection
from cloudsdk.google.protobuf import symbol_database as _symbol_database

# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()


DESCRIPTOR = _descriptor.FileDescriptor(
    name="google/type/month.proto",
    package="google.type",
    syntax="proto3",
    serialized_options=b"\n\017com.google.typeB\nMonthProtoP\001Z6google.golang.org/genproto/googleapis/type/month;month\242\002\003GTP",
    create_key=_descriptor._internal_create_key,
    serialized_pb=b"\n\x17google/type/month.proto\x12\x0bgoogle.type*\xb0\x01\n\x05Month\x12\x15\n\x11MONTH_UNSPECIFIED\x10\x00\x12\x0b\n\x07JANUARY\x10\x01\x12\x0c\n\x08\x46\x45\x42RUARY\x10\x02\x12\t\n\x05MARCH\x10\x03\x12\t\n\x05\x41PRIL\x10\x04\x12\x07\n\x03MAY\x10\x05\x12\x08\n\x04JUNE\x10\x06\x12\x08\n\x04JULY\x10\x07\x12\n\n\x06\x41UGUST\x10\x08\x12\r\n\tSEPTEMBER\x10\t\x12\x0b\n\x07OCTOBER\x10\n\x12\x0c\n\x08NOVEMBER\x10\x0b\x12\x0c\n\x08\x44\x45\x43\x45MBER\x10\x0c\x42]\n\x0f\x63om.google.typeB\nMonthProtoP\x01Z6google.golang.org/genproto/googleapis/type/month;month\xa2\x02\x03GTPb\x06proto3",
)

_MONTH = _descriptor.EnumDescriptor(
    name="Month",
    full_name="google.type.Month",
    filename=None,
    file=DESCRIPTOR,
    create_key=_descriptor._internal_create_key,
    values=[
        _descriptor.EnumValueDescriptor(
            name="MONTH_UNSPECIFIED",
            index=0,
            number=0,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="JANUARY",
            index=1,
            number=1,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="FEBRUARY",
            index=2,
            number=2,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="MARCH",
            index=3,
            number=3,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="APRIL",
            index=4,
            number=4,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="MAY",
            index=5,
            number=5,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="JUNE",
            index=6,
            number=6,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="JULY",
            index=7,
            number=7,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="AUGUST",
            index=8,
            number=8,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="SEPTEMBER",
            index=9,
            number=9,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="OCTOBER",
            index=10,
            number=10,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="NOVEMBER",
            index=11,
            number=11,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
        _descriptor.EnumValueDescriptor(
            name="DECEMBER",
            index=12,
            number=12,
            serialized_options=None,
            type=None,
            create_key=_descriptor._internal_create_key,
        ),
    ],
    containing_type=None,
    serialized_options=None,
    serialized_start=41,
    serialized_end=217,
)
_sym_db.RegisterEnumDescriptor(_MONTH)

Month = enum_type_wrapper.EnumTypeWrapper(_MONTH)
MONTH_UNSPECIFIED = 0
JANUARY = 1
FEBRUARY = 2
MARCH = 3
APRIL = 4
MAY = 5
JUNE = 6
JULY = 7
AUGUST = 8
SEPTEMBER = 9
OCTOBER = 10
NOVEMBER = 11
DECEMBER = 12


DESCRIPTOR.enum_types_by_name["Month"] = _MONTH
_sym_db.RegisterFileDescriptor(DESCRIPTOR)


DESCRIPTOR._options = None
# @@protoc_insertion_point(module_scope)

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.8.0] - 2019-10-08
### Added
- Super::Heritage

### Fixed
- Serializer and Struct heritage

## [0.7.0] - 2019-09-18
### Added
- String codec

## [0.6.2] - 2019-09-16
- Fixes redis cache delete command

## [0.6.1] - 2019-08-08
### Added
- Redis cache

### Changed
- Marshalling cache entries

## [0.6.0] - 2019-08-06
### Removed
- Integer and Float codec.

## [0.5.1] - 2019-08-06
### Added
- Integer codec.

### Changed
- Codec error messages.

## [0.5.0] - 2019-07-19
### Fixed
- App settings load order.

### Added:
- ResourcePool minor improvements.
- Improved delegate handling in Super::Component.
- Additional specs.

## [0.4.0] - 2019-07-09
### Added:
- Default Float Codec.

## [0.3.2] - 2019-07-04
### Fixed:
- Attribute decoder error when attribute type is a Super::Struct object
- Make kafka processor log to the application logger and print the backtrace.

## [0.3.1] - 2019-06-26
### Fixed:
- Attribute decoder error when attribute type is defined and codec doesn't exist.

## [0.3.0] - 2019-06-26
### Added:
- Super Struct Attribute decoder support.
- Default Time Codec (Super Struct auto-decodes ISO 8601 strings).

## [0.2.1] - 2019-06-21
### Fixed:
- Application.loader

## [0.2.0] - 2019-06-20
### Added:
- super

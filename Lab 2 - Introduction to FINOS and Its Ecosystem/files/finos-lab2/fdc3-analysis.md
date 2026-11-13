# FDC3 Analysis

## Purpose
FDC3 (Financial Desktop Connectivity and Collaboration Consortium) defines standards for interoperability between financial desktop applications.

## Key concepts
1. **Context:** Standardized data about financial entities, such as instruments and organizations.
2. **Intents:** Named actions that allow applications to request another application capability.
3. **App Directory:** A registry of applications and their capabilities.
4. **Desktop Agent:** A runtime that supports application discovery and inter-application communication.

## Example workflow
A market-data application broadcasts an `fdc3.instrument` context. A connected trading or research application can receive that context and display information about the same instrument.

## Important distinction
These JSON files are illustrative examples. They do not by themselves implement an FDC3 Desktop Agent or prove conformance to a particular FDC3 specification version.

# Xtext Language Server Example

## Quickstart

- Run `./gradlew run`

This will start the server with the help of `org.xtext.example.mydsl.websockets.RunWebSocketServer3`.

## Project Structure

- `org.xtext.example.mydsl` (contains the dsl)
- `org.xtext.example.mydsl.ide` (contains the dsl specific customizations of the Xtext language server)
- `org.xtext.example.mydsl.tests`
- `org.xtext.example.mydsl.websockets` (contains the code to launch a websocket and the server and tie them to each other)

## Building in Details

1. Make sure that `java -version` is executable and pointing to a Java 8+ JDK.

### Scenario 1 (client-only with separate server process)

1. Run `./gradlew run` or launch RunServer from Eclipse.

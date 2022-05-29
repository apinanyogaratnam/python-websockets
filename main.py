import asyncio
import websockets

connections = set()


async def echo(websocket, path):
    connections.add(websocket)
    try:
        async for message in websocket:
            for connection in connections:
                if connection != websocket:
                    await connection.send(
                        f'received message from connection {list(connections).index(connection)}: {message}'
                    )
    finally:
        connections.remove(websocket)


start_server = websockets.serve(echo, '0.0.0.0', 8000)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

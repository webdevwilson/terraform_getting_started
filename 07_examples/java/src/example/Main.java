package example;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

public class Main {
    
    public static void main(String[] args) throws Exception {
        final int port = Integer.parseInt(System.getenv().get("PORT"));
        final String message = System.getenv("MSG");

        final HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        server.createContext("/greeting", (t) -> {
            t.sendResponseHeaders(200, message.length());
            OutputStream os = t.getResponseBody();
            os.write(message.getBytes());
            os.close();
        });
        server.start();
    }
}
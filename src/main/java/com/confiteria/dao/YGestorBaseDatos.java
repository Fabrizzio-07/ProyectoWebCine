package com.confiteria.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class YGestorBaseDatos {

    private final String SERVER =
            System.getenv().getOrDefault("DB_HOST", "localhost");

    private final String PORT =
            System.getenv().getOrDefault("DB_PORT", "1433");

    private final String DATABASE =
            System.getenv().getOrDefault("DB_NAME", "confiteria");

    private final String USER = System.getenv("DB_USER");
    private final String PASS = System.getenv("DB_PASSWORD");

    private final String URL =
            "jdbc:sqlserver://" + SERVER + ":" + PORT +
            ";databaseName=" + DATABASE +
            ";encrypt=false;";

    public Connection getConnection() {

        if (USER == null || USER.isBlank() ||
            PASS == null || PASS.isBlank()) {
            throw new IllegalStateException(
                "Faltan las variables DB_USER o DB_PASSWORD."
            );
        }

        try {
            Class.forName(
                "com.microsoft.sqlserver.jdbc.SQLServerDriver"
            );

            return DriverManager.getConnection(URL, USER, PASS);

        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                "No se encontró el driver JDBC.", e
            );

        } catch (SQLException e) {
            throw new RuntimeException(
                "Error al conectar con SQL Server.", e
            );
        }
    }

    public void closeConnection(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
            }
        } catch (SQLException e) {
            throw new RuntimeException(
                "Error al cerrar la conexión.", e
            );
        }
    }
}
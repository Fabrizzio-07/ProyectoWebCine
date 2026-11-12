package com.confiteria.controlador;

import com.confiteria.dao.YGestorPersonal;
import com.confiteria.modelo.Rol;
import com.confiteria.modelo.YPersonal;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RegistroPersonalServlet")
public class RegistroPersonalServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Obtener datos del formulario
        String nombre = request.getParameter("nombreCompleto");
        if(!nombre.matches("[A-Za-zÁÉÍÓÚáéíóúÑñ ]+")){
    response.sendRedirect("registro.jsp?error=nombre");
    return;
}
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");
        String confirmar = request.getParameter("confirmarPassword");

        int idRol = Integer.parseInt(request.getParameter("idRol"));

        boolean estado =
                request.getParameter("estado").equals("1");

        // Validar contraseña
        if (!password.equals(confirmar)) {

            response.sendRedirect("registro.jsp?error=password");

            return;
        }

        // Crear objeto Personal
        YPersonal personal = new YPersonal();

        personal.setNombreCompleto(nombre);
        personal.setUsuario(usuario);
        personal.setPassword(encriptarSHA256(password));
        personal.setEstado(estado);

        Rol rol = new Rol();
        rol.setIdRol(idRol);

        personal.setRol(rol);

        // Guardar
        YGestorPersonal gestor = new YGestorPersonal();

        boolean registrado =
                gestor.insertarPersonal(personal);

        if (registrado) {

            response.sendRedirect("personal.jsp?registro=ok");

        } else {

            response.sendRedirect("registro.jsp?error=bd");

        }

    }
    
    
    private String encriptarSHA256(String texto) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(texto.getBytes(java.nio.charset.StandardCharsets.UTF_8));

            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02X", b));
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error al encriptar contraseña", e);
        }
    }
    
}

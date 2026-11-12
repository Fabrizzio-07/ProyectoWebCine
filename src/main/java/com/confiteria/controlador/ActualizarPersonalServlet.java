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

@WebServlet("/ActualizarPersonalServlet")
public class ActualizarPersonalServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombreCompleto");
        if(!nombre.matches("[A-Za-zÁÉÍÓÚáéíóúÑñ ]+")){
    response.sendRedirect("editarPersonal.jsp?error=nombre");
    return;
}
        String usuario = request.getParameter("usuario");
        String password = request.getParameter("password");
        int idRol = Integer.parseInt(request.getParameter("idRol"));
        boolean estado = request.getParameter("estado").equals("1");

        Rol rol = new Rol();
        rol.setIdRol(idRol);

        YPersonal personal = new YPersonal();
        personal.setIdPersonal(id);
        personal.setNombreCompleto(nombre);
        personal.setUsuario(usuario);
        personal.setPassword(encriptarSHA256(password));
        personal.setRol(rol);
        personal.setEstado(estado);

        YGestorPersonal gestor = new YGestorPersonal();

        gestor.actualizarPersonal(personal);

        response.sendRedirect("personal.jsp?mensaje=actualizado");
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
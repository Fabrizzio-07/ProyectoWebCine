package com.confiteria.controlador;

import com.confiteria.dao.YGestorPersonal;
import com.confiteria.modelo.YPersonal;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user = request.getParameter("txtUsuario");
        String pass = request.getParameter("txtPassword");
        
        //capturar botn 
        String accionBoton = request.getParameter("btnAccion"); 
        
        YGestorPersonal gestor = new YGestorPersonal();
        YPersonal personalEncontrado = gestor.validarLogin(user, pass);

        if (personalEncontrado != null) {
            
            //Extraer rol
            String rolUsuario = personalEncontrado.getRol().getNombreRol();

            //Seguridad botones
            //Si es Administrador 
            if ("ingresoNormal".equals(accionBoton) && rolUsuario.equalsIgnoreCase("Administrador")) {
                request.setAttribute("error", "Acceso denegado. Utilice el botón 'Ingresar con administrador'.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return; 
            }
            
            //Si es Cajero 
            if ("ingresoAdmin".equals(accionBoton) && rolUsuario.equalsIgnoreCase("Cajero")) {
                request.setAttribute("error", "Acceso denegado. No tienes permisos de Administrador.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return; 
            }
            
            //iniciar sesión
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", personalEncontrado);

            // apartado recordar
            String recordarme = request.getParameter("chkRecordarme");
            if (recordarme != null) {
                Cookie cookieUsuario = new Cookie("usuarioRecordado", user);
                cookieUsuario.setMaxAge(60 * 60 * 24 * 30); // 30 días
                cookieUsuario.setPath("/"); 
                response.addCookie(cookieUsuario);
            } else {
                Cookie cookieUsuario = new Cookie("usuarioRecordado", "");
                cookieUsuario.setMaxAge(0); // Borrar
                cookieUsuario.setPath("/"); 
                response.addCookie(cookieUsuario);
            }

            //Redirección a su pantalla correspondiente
            if (rolUsuario.equalsIgnoreCase("Cajero")) {
                response.sendRedirect("ventas.jsp");
            } else if (rolUsuario.equalsIgnoreCase("Administrador")) {
                response.sendRedirect("inicio.jsp");
            } else {
                request.setAttribute("error", "Rol de usuario no autorizado.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
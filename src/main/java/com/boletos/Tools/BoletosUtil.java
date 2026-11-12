/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.boletos.Tools;

/**
 *
 * @author ancaj
 */


import com.confiteria.modelo.YPersonal;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class BoletosUtil {

    private BoletosUtil() {
    }

    public static YPersonal obtenerUsuario(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;

        Object obj = session.getAttribute("usuarioLogueado");
        if (obj instanceof YPersonal) {
            return (YPersonal) obj;
        }
        return null;
    }

    public static String obtenerRol(HttpServletRequest request) {
        YPersonal usuario = obtenerUsuario(request);
        if (usuario == null || usuario.getRol() == null) return null;
        return usuario.getRol().getNombreRol();
    }

    public static boolean esCajero(HttpServletRequest request) {
        String rol = obtenerRol(request);
        return rol != null && rol.equalsIgnoreCase("Cajero");
    }

    public static boolean esAdministrador(HttpServletRequest request) {
        String rol = obtenerRol(request);
        return rol != null && rol.equalsIgnoreCase("Administrador");
    }

    public static String obtenerNombreUsuario(HttpServletRequest request) {
        YPersonal usuario = obtenerUsuario(request);
        return usuario != null ? usuario.getNombreCompleto() : "Usuario";
    }
}

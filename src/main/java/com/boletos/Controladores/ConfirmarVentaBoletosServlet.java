/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.boletos.Controladores;

import com.boletos.Tools.BoletosUtil;
import com.confiteria.modelo.YPersonal;
import com.boletos.BD.HorarioFuncionBoletosBD;
import com.boletos.BD.PeliculaBoletosBD;
import com.boletos.BD.VentaBoletosBD;
import com.boletos.Clases.HorarioFuncionBoletos;
import com.boletos.Clases.PeliculaBoletos;
import com.boletos.Clases.VentaAsientoBoletos;
import com.boletos.Clases.VentaBoletos;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author ancaj
 */
@WebServlet(name = "ConfirmarVentaBoletosServlet", urlPatterns = {"/ConfirmarVentaBoletosServlet"})
public class ConfirmarVentaBoletosServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    private final VentaBoletosBD ventaBD = new VentaBoletosBD();
    private final PeliculaBoletosBD peliculaBD = new PeliculaBoletosBD();
    private final HorarioFuncionBoletosBD horarioBD = new HorarioFuncionBoletosBD();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/CajeroPeliculasServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!BoletosUtil.esCajero(request)) {
            if (BoletosUtil.esAdministrador(request)) {
                response.sendRedirect(request.getContextPath() + "/inicio.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int idPersonal = obtenerIdPersonal(request);
            if (idPersonal <= 0) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            String idHorarioStr = valorRequerido(request, "idHorario");
            String codigoPelicula = valorRequerido(request, "codigoPelicula");
            String cliente = valorRequerido(request, "cliente");
            String fechaFuncionStr = valorRequerido(request, "fechaFuncion");

            int idHorario = Integer.parseInt(idHorarioStr.trim());
            HorarioFuncionBoletos horario = horarioBD.obtenerPorId(idHorario);
            if (horario == null) {
                request.setAttribute("error", "No se encontró el horario seleccionado.");
                forwardConfirmacion(request, response);
                return;
            }

            PeliculaBoletos pelicula = peliculaBD.obtenerPorCodigo(codigoPelicula);
            if (pelicula == null) {
                request.setAttribute("error", "No se encontró la película seleccionada.");
                forwardConfirmacion(request, response);
                return;
            }

            ArrayList<VentaAsientoBoletos> asientos = construirAsientos(request);
            if (asientos.size() == 0) {
                request.setAttribute("error", "Debes seleccionar al menos un asiento.");
                forwardConfirmacion(request, response);
                return;
            }

            LocalDate fechaFuncion = LocalDate.parse(fechaFuncionStr.trim());
            LocalTime horaFuncion = horario.getHoraFuncion();

            if (fechaFuncion.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("No se puede vender boletos para una fecha anterior a hoy.");
            }

            if (fechaFuncion.isEqual(LocalDate.now())) {
                LocalTime ahora = LocalTime.now().withSecond(0).withNano(0);
                LocalTime finFuncion = horaFuncion.plusMinutes(pelicula.getDuracionMinutos());

                if (!ahora.isBefore(finFuncion)) {
                    throw new IllegalArgumentException("No se puede vender boletos porque la función ya terminó.");
                }
            }

            BigDecimal precioUnitario = BigDecimal.valueOf(pelicula.getPrecioBase());
            BigDecimal total = precioUnitario
                    .multiply(BigDecimal.valueOf(asientos.size()))
                    .setScale(2, RoundingMode.HALF_UP);

            VentaBoletos venta = new VentaBoletos();
            venta.setIdPersonal(idPersonal);
            venta.setCliente(cliente.trim());
            venta.setCodigoPelicula(pelicula.getCodigo());
            venta.setNombrePelicula(pelicula.getNombre());
            venta.setTipo(pelicula.getTipo());
            venta.setIdHorario(horario.getIdHorario());
            venta.setSala(horario.getSala());
            venta.setHoraFuncion(horaFuncion);
            venta.setFechaFuncion(fechaFuncion);
            venta.setHoraCompra(LocalTime.now().withSecond(0).withNano(0));
            venta.setFechaCompra(LocalDate.now());
            venta.setMontoTotal(total);

            int idVentaGenerada = ventaBD.registrarVenta(venta, asientos);
            venta.setIdVenta(idVentaGenerada);

            request.setAttribute("mensajeExito", "Venta registrada correctamente.");
            request.setAttribute("idVentaGenerada", idVentaGenerada);
            request.setAttribute("ventaRegistrada", venta);
            request.setAttribute("asientosSeleccionados", asientos);

            forwardConfirmacion(request, response);

        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage());
            forwardConfirmacion(request, response);
        } catch (DateTimeParseException ex) {
            request.setAttribute("error", "La fecha u hora ingresada no tiene un formato válido.");
            forwardConfirmacion(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", ex.getMessage());
            forwardConfirmacion(request, response);
        }
    }

    private void forwardConfirmacion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/boletos_confirmarVenta.jsp");
        rd.forward(request, response);
    }

    private String valorRequerido(HttpServletRequest request, String nombre) {
        String valor = request.getParameter(nombre);
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException("Falta el parámetro obligatorio: " + nombre);
        }
        return valor.trim();
    }

    private int obtenerIdPersonal(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            Object usuario = session.getAttribute("usuarioLogueado");
            if (usuario instanceof YPersonal) {
                return ((YPersonal) usuario).getIdPersonal();
            }

            Object valor = session.getAttribute("id_personal");
            if (valor == null) {
                valor = session.getAttribute("idPersonal");
            }

            if (valor instanceof Number) {
                return ((Number) valor).intValue();
            }

            if (valor != null) {
                try {
                    return Integer.parseInt(valor.toString());
                } catch (NumberFormatException ignored) {
                }
            }
        }

        String idParam = request.getParameter("idPersonal");
        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = request.getParameter("id_personal");
        }

        if (idParam != null && !idParam.trim().isEmpty()) {
            return Integer.parseInt(idParam.trim());
        }

        return 0;
    }

    private ArrayList<VentaAsientoBoletos> construirAsientos(HttpServletRequest request) {
        ArrayList<VentaAsientoBoletos> lista = new ArrayList<VentaAsientoBoletos>();
        ArrayList<String> asientosTexto = new ArrayList<String>();

        agregarDesdeArray(asientosTexto, request.getParameterValues("asientos"));
        agregarDesdeArray(asientosTexto, request.getParameterValues("asientosSeleccionados"));
        agregarDesdeArray(asientosTexto, request.getParameterValues("asiento"));

        String asientoUnico = request.getParameter("asiento");
        if (asientoUnico != null && !asientoUnico.trim().isEmpty()) {
            agregarUnico(asientosTexto, asientoUnico.trim());
        }

        String asientosCsv = request.getParameter("asientosCsv");
        if (asientosCsv != null && !asientosCsv.trim().isEmpty()) {
            String[] partes = asientosCsv.split(",");
            for (int i = 0; i < partes.length; i++) {
                String asiento = partes[i].trim();
                if (!asiento.isEmpty()) {
                    agregarUnico(asientosTexto, asiento);
                }
            }
        }

        for (int i = 0; i < asientosTexto.size(); i++) {
            VentaAsientoBoletos va = new VentaAsientoBoletos();
            va.setAsiento(asientosTexto.get(i));
            lista.add(va);
        }

        return lista;
    }

    private void agregarDesdeArray(ArrayList<String> destino, String[] valores) {
        if (valores == null) {
            return;
        }

        for (int i = 0; i < valores.length; i++) {
            String valor = valores[i];
            if (valor != null && !valor.trim().isEmpty()) {
                agregarUnico(destino, valor.trim());
            }
        }
    }

    private void agregarUnico(ArrayList<String> lista, String valor) {
        for (int i = 0; i < lista.size(); i++) {
            if (lista.get(i).equalsIgnoreCase(valor)) {
                return;
            }
        }
        lista.add(valor);
    }
}

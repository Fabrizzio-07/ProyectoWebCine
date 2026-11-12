<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%> 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso | Cine Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Fondo cine */
        body {
            background-image: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.95)), url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=2070&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        /* Estilos del logo superior */
        .logo-container {
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
        }
        .logo-icon {
            color: #e50914; 
            margin-right: 10px;
            font-size: 32px;
        }

        /* Tarjeta principal del login */
        .login-card {
            background-color: #121212;
            border-radius: 12px;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.8);
            border: 1px solid #2a2a2a;
        }

        /* Ícono de avatar */
        .avatar-circle {
            width: 65px;
            height: 65px;
            border-radius: 50%;
            background-color: #1a1a1a;
            border: 2px solid #333;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 20px;
        }

        /* Textos de bienvenida */
        .welcome-title {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 5px;
        }
        .text-red {
            color: #e50914 !important;
        }
        .welcome-subtitle {
            color: #888;
            font-size: 14px;
            text-align: center;
            margin-bottom: 30px;
        }

        /* Inputs personalizados */
        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #ccc;
            margin-bottom: 8px;
        }
        .input-group-custom {
            position: relative;
            margin-bottom: 20px;
        }
        .input-group-custom i.icon-left {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
        }
        .input-group-custom i.icon-right {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
            cursor: pointer;
        }
        .form-control-custom {
            width: 100%;
            background-color: #1a1a1a;
            border: 1px solid #333;
            color: #fff;
            padding: 12px 40px 12px 45px;
            border-radius: 6px;
            transition: border-color 0.3s;
        }
        .form-control-custom:focus {
            outline: none;
            border-color: #e50914;
            background-color: #222;
        }
        .form-control-custom::placeholder {
            color: #555;
            font-size: 14px;
        }

        /* Checkbox y enlaces */
        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            margin-bottom: 25px;
        }
        .form-check-input {
            background-color: transparent;
            border-color: #555;
            cursor: pointer;
        }
        .form-check-input:checked {
            background-color: #e50914;
            border-color: #e50914;
        }
        .form-check-label {
            color: #aaa;
            cursor: pointer;
        }
        .forgot-link {
            color: #e50914;
            text-decoration: none;
            cursor: pointer;
        }
        .forgot-link:hover {
            color: #f40612;
            text-decoration: underline;
        }

        /* Botones */
        .btn-primary-custom {
            background-color: #e50914;
            color: white;
            border: none;
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            font-weight: 600;
            margin-bottom: 20px;
            transition: background-color 0.3s;
        }
        .btn-primary-custom:hover {
            background-color: #f40612;
        }

        .divider {
            text-align: center;
            position: relative;
            margin-bottom: 20px;
        }
        .divider::before {
            content: "";
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background-color: #333;
            z-index: 1;
        }
        .divider span {
            background-color: #121212;
            padding: 0 15px;
            color: #666;
            font-size: 12px;
            position: relative;
            z-index: 2;
        }

        .btn-admin {
            background-color: transparent;
            border: 1px solid #333;
            color: #fff;
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            font-weight: 500;
            display: flex;
            justify-content: center;
            align-items: center;
            transition: all 0.3s;
            cursor: pointer;
        }
        .btn-admin i {
            color: #e50914;
            margin-right: 8px;
        }
        .btn-admin:hover {
            border-color: #e50914;
            background-color: rgba(229, 9, 20, 0.05);
        }

        /* Footer */
        .footer-text {
            margin-top: 30px;
            font-size: 12px;
            color: #666;
        }
    </style>
</head>
<body>

    <div class="logo-container">
        <i class="fa-solid fa-clapperboard logo-icon"></i> 
        <span>CINE <span style="font-weight: normal;">SISTEMA</span></span>
    </div>

    <div class="login-card">
        
        <div class="avatar-circle">
            <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="#e50914" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
            </svg>
        </div>

        <h2 class="welcome-title">Bienvenido <span class="text-red">de nuevo</span></h2>
        <p class="welcome-subtitle">Inicie sesión para continuar</p>

        ${not empty error ? '<div class="alert alert-danger p-2 text-center" style="font-size: 13px;">' += error += '</div>' : ''}

        <form action="LoginServlet" method="POST">
            
            <label class="form-label">Usuario</label>
            <div class="input-group-custom">
                <i class="fa-regular fa-user icon-left"></i>
                <input type="text" name="txtUsuario" class="form-control-custom" placeholder="Ej: cajero01 o admin01" value="${cookie.usuarioRecordado.value}" required>
            </div>

            <label class="form-label">Contraseña</label>
            <div class="input-group-custom">
                <i class="fa-solid fa-lock icon-left"></i>
                <input type="password" name="txtPassword" id="passwordInput" class="form-control-custom" placeholder="Ingrese su contraseña" required>
                <i class="fa-regular fa-eye icon-right" id="togglePassword"></i>
            </div>

            <div class="options-row">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="rememberMe" name="chkRecordarme">
                    <label class="form-check-label" for="rememberMe">Recordarme</label>
                </div>
                <a data-bs-toggle="modal" data-bs-target="#modalRecuperar" class="forgot-link">¿Olvidaste tu contraseña?</a>
            </div>

            <button type="submit" name="btnAccion" value="ingresoNormal" class="btn-primary-custom">Ingresar al Sistema</button>
            
            <div class="divider">
                <span>o</span>
            </div>

            <button type="submit" name="btnAccion" value="ingresoAdmin" class="btn-admin">
                <i class="fa-solid fa-shield-halved"></i> Ingresar con administrador
            </button>

        </form>
    </div>

    <div class="footer-text">
        © 2024 Cine Sistema. Todos los derechos reservados.
    </div>

    <div class="modal fade" id="modalRecuperar" tabindex="-1" data-bs-theme="dark">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content" style="background-color: #1a1a1a; border: 1px solid #333; border-radius: 12px;">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title text-white"><i class="fa-solid fa-key text-red me-2"></i>Recuperar Contraseña</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body pb-0">
                    <p style="color: #aaa; font-size: 14px;">Ingresa tu usuario del sistema. Se notificará directamente a la administración.</p>
                    <div class="input-group-custom mb-3">
                        <i class="fa-regular fa-user icon-left"></i>
                        <input type="text" id="inputUsuarioRecuperar" class="form-control-custom" placeholder="Ingresa tu usuario">
                    </div>
                </div>
                <div class="modal-footer border-top-0">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="border-radius: 6px;">Cancelar</button>
                    <button type="button" class="btn btn-primary-custom m-0" style="width: auto; padding: 6px 20px;" onclick="enviarSolicitud()">Enviar Solicitud</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Lógica para mostrar yocultar contraseña
        const togglePassword = document.querySelector('#togglePassword');
        const passwordInput = document.querySelector('#passwordInput');

        togglePassword.addEventListener('click', function (e) {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });

        // Lógica para recuperar contraseña
        function enviarSolicitud() {
            const input = document.getElementById("inputUsuarioRecuperar");
            const usuarioEmpleado = input.value.trim();
            
            if(usuarioEmpleado === "") {
                Swal.fire({
                    icon: 'warning',
                    title: 'Cine Sistema',
                    text: 'Por favor, ingresa tu usuario para continuar.',
                    confirmButtonColor: '#e50914'
                });
                input.focus();
                return;
            }
            
            // Ocultar modal
            const modalElement = document.getElementById('modalRecuperar');
            const modalInstance = bootstrap.Modal.getInstance(modalElement);
            if (modalInstance) { modalInstance.hide(); }
            
            // Destruir el fondo oscuro 
            document.body.classList.remove('modal-open');
            document.querySelectorAll('.modal-backdrop').forEach(fondo => fondo.remove());
            document.body.style.overflow = 'auto'; 
            
            // Limpiar la caja de texto
            input.value = "";
            
            // Alerta
            Swal.fire({
                icon: 'success',
                title: 'Cine Sistema',
                text: "Solicitud enviada para '" + usuarioEmpleado + "'. Acércate al Administrador del sistema para que te asigne una nueva contraseña.",
                confirmButtonColor: '#e50914',
                background: '#1a1a1a',
                color: '#ffffff'
            });
        }
    </script>
</body>
</html>
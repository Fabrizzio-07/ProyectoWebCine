<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña | Cine Sistema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Mismo estilo login */
        body {
            background-image: linear-gradient(rgba(0, 0, 0, 0.85), rgba(0, 0, 0, 0.95)), url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=2070&auto=format&fit=crop');
            background-size: cover; background-position: center; background-attachment: fixed;
            color: #ffffff; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh; display: flex; flex-direction: column; justify-content: center; align-items: center;
        }
        .logo-container { margin-bottom: 20px; font-size: 24px; font-weight: bold; display: flex; align-items: center; }
        .logo-icon { color: #e50914; margin-right: 10px; font-size: 32px; }
        .login-card {
            background-color: #121212; border-radius: 12px; padding: 40px; width: 100%; max-width: 420px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.8); border: 1px solid #2a2a2a; text-align: center;
        }
        .avatar-circle {
            width: 65px; height: 65px; border-radius: 50%; background-color: #1a1a1a;
            border: 2px solid #333; display: flex; justify-content: center; align-items: center; margin: 0 auto 20px;
        }
        .avatar-circle i { color: #e50914; font-size: 26px; }
        .welcome-title { font-size: 22px; font-weight: bold; margin-bottom: 10px; }
        .welcome-subtitle { color: #888; font-size: 14px; margin-bottom: 30px; }
        
        /* Inputs y Botones */
        .form-label { font-size: 13px; font-weight: 600; color: #ccc; margin-bottom: 8px; text-align: left; display: block; }
        .input-group-custom { position: relative; margin-bottom: 25px; }
        .input-group-custom i.icon-left { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #888; }
        .form-control-custom {
            width: 100%; background-color: #1a1a1a; border: 1px solid #333; color: #fff;
            padding: 12px 40px 12px 45px; border-radius: 6px; transition: border-color 0.3s;
        }
        .form-control-custom:focus { outline: none; border-color: #e50914; background-color: #222; }
        
        .btn-primary-custom {
            background-color: #e50914; color: white; border: none; width: 100%; padding: 12px;
            border-radius: 6px; font-weight: 600; margin-bottom: 15px; transition: 0.3s;
        }
        .btn-primary-custom:hover { background-color: #f40612; }
        .btn-back {
            background-color: transparent; border: 1px solid #333; color: #aaa; width: 100%;
            padding: 10px; border-radius: 6px; text-decoration: none; display: block; font-size: 14px; transition: 0.3s;
        }
        .btn-back:hover { border-color: #555; color: #fff; background-color: rgba(255,255,255,0.05); }
    </style>
</head>
<body>

    <div class="logo-container">
        <i class="fa-solid fa-clapperboard logo-icon"></i> 
        <span>CINE <span style="font-weight: normal;">SISTEMA</span></span>
    </div>

    <div class="login-card">
        
        <div class="avatar-circle">
            <i class="fa-solid fa-key"></i>
        </div>

        <h2 class="welcome-title">Recuperar Contraseña</h2>
        <p class="welcome-subtitle">Ingrese su usuario para solicitar el restablecimiento con el Administrador.</p>

      
        <form action="#" method="POST">
            
            <label class="form-label">Usuario registrado</label>
            <div class="input-group-custom">
                <i class="fa-regular fa-user icon-left"></i>
                <input type="text" name="txtUsuarioRecuperar" class="form-control-custom" placeholder="Ej: cajero01" required>
            </div>

            <button type="button" class="btn-primary-custom" onclick="alert('Solicitud enviada al administrador del cine.');">Enviar Solicitud</button>
            
            <a href="login.jsp" class="btn-back">
                <i class="fa-solid fa-arrow-left me-2"></i> Volver al Login
            </a>

        </form>
    </div>

</body>
</html>
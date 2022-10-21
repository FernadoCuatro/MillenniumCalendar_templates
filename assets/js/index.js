function validarcontraseña() {

    // Dos inputs al obtener valor
    var password1 = document.getElementById('login_datos_login_inserta');
    var password2 = document.getElementById('login_datos_login_actualiza');

    // Boton a desabilitar
    var desabilitar = document.getElementById('envio');

    if (password1.value !== password2.value) {
        document.getElementById('alertacontrasenia').innerHTML = "Debe coincidir con las contraseñas";
        desabilitar.disabled = true;
    } else {
        document.getElementById('alertacontrasenia').innerHTML = " ";
        desabilitar.disabled = false;
    }
}
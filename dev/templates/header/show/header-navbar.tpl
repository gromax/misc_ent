<nav class="navbar navbar-dark bg-primary navbar-expand-lg">
  <a class="navbar-brand js-home" href="#Home">Boîte à outils pour l'ENT &nbsp; <span class="js-spinner"></span></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent">
    <span class="navbar-toggler-icon"></span>
  </button>

  <div class="collapse navbar-collapse" id="navbarSupportedContent">
    <% if (isOff) { %>
    <ul class="navbar-nav ml-auto">
      <li class="nav-item"><a class="nav-link js-login" href="./api/cas"><i class="fa fa-sign-in"></i> Connexion</a></li>
    </ul>
    <%} else {%>
    <ul class="navbar-nav ml-auto">
      <li class="nav-item"><a class="nav-link" href="#" inactive><i class="fa fa-user"></i> &nbsp; <%- displayName %></a></li>
      <li class="nav-item"><a class="nav-link js-logout" href="#"><i class="fa fa-sign-out"></i></a></li>
    </ul>
    <%}%>
    <span class="navbar-text">Version <%- version %></span>
  </div>
</nav>

<h1>Bienvenue !</h1>
<p>Vous êtes <b><%- displayName %></b>.</p>
<div class="list-group">
  <a type="button" class="list-group-item list-group-item-action js-rdv-psy" href="#rdv-psy"><i class="fa fa-calendar"></i> Prendre rendez-vous aves un psy.</a>
  <% if (isAdmin) { %>
  <a type="button" class="list-group-item list-group-item-action list-group-item-warning js-admin-droits" href="#admin-droits"><i class="fa fa-user"></i> Définir les droits des utilisateurs <b>[Admin]</b>.</a>
  <% } %>
</div>

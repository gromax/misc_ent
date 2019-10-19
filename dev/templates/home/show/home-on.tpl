<h1>Bienvenue !</h1>
<p>Vous êtes <b><%- displayName %></b> [<i><%- login %></i>]</p>
<div class="list-group">
  <a type="button" class="list-group-item list-group-item-action js-rdv-psy" href="#rdv-psy"><i class="fa fa-calendar"></i> Prendre rendez-vous.</a>
  <% if(droits.indexOf(1)>-1) { %>
  <a type="button" class="list-group-item list-group-item-action list-group-item-warning js-admin-list-rendezVous" href="#admin/rendezVous/list">Définir un type de rendez-vous.</a>
  <% } %>
  <% if (isAdmin) { %>
  <a type="button" class="list-group-item list-group-item-action list-group-item-warning js-admin-droits" href="#droits"><i class="fa fa-user"></i> Définir les droits des utilisateurs <b>[Admin]</b>.</a>
  <% } %>
</div>

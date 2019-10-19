<td><span class="badge badge-pill badge-primary"><%- id %></span></td>
<td><%- idEntUser %><% if (emailUser != "") { %><br/><small class="text-info"><i class="fa fa-envelope fa-1"></i><%- emailUser %></small><% } %></td>
<td><%- title %><br /><small class="text-info"><%- description %></small></td>
<td><%- filter %></td>
<td><%- rdvTime %></td>
<td align="right">
  <div class="btn-group" role="group">
    <!-- Bouton suppression -->
    <button type="button" class="btn btn-danger btn-sm js-delete"><i class="fa fa-trash" aria-hidden="true" title="Supprimer"></i></button>
  </div>
</td>

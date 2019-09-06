<div class="row">
<div class="col-auto mr-auto"><h1><%-title%></h1></div>
<div class="col-auto">
<form id="filter-form" class="form-search form-inline" style="margin-bottom: 10px;">
  <div class="input-group">
    <span class="input-group-btn">
      <% if (showAddButton) {%><button class="btn btn-primary js-new" type="button"><i class="fa fa-plus"></i></button><% } %>
    </span>
    <input type="text" class="form-control search-query js-filter-criterion" placeholder="Filtrer..." value="<%- filterCriterion %>">
    <span class="input-group-btn">
      <button class="btn btn-primary" type="submit"><i class="fa fa-search"></i></button>
    </span>
  </div>
</form>
</div>
</div>

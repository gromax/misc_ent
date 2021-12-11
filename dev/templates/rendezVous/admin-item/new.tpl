<form>
  <div class="form-group">
    <label for="item-dateFr" class="control-label">Date des créneaux :</label>
    <input class="datepicker form-control" id="item-dateFr" name="dateFr" data-date-format="dd/mm/yyyy" data-date-language="fr" data-date-today-highlight="1" data-date-autoclose="1" data-provide="datepicker">
    <!--<input class="form-control" id="item-date" name="date" type="text" placeHolder="Date"/>-->
  </div>

  <div class="form-group">
    <label for="item-debut" class="control-label">Heure de début :</label>
    <input class="form-control" id="item-debut" name="debut" type="text" placeHolder="Heure de début"/>
  </div>

  <div class="form-group">
    <label for="item-nombre" class="control-label">nombre de créneaux :</label>
    <input class="form-control" id="item-nombre" name="nombre" type="text" placeHolder="nombre de créneaux" value="1"/>
  </div>

  <div class="form-group">
    <label for="item-duree" class="control-label">Durée de chaque créneau en minutes :</label>
    <input class="form-control" id="item-duree" name="duree" type="text" placeHolder="durée en minutes" value="15"/>
  </div>

  <button class="btn btn-success js-submit">Enregistrer</button>
</form>

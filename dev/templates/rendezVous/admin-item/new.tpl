<form>
  <div class="form-group">
    <label for="item-dateFr" class="control-label">Date du créneau :</label>
    <input class="datepicker form-control" id="item-dateFr" name="dateFr" data-date-format="dd/mm/yyyy" data-date-language="fr" data-date-today-highlight="1" data-date-autoclose="1" data-provide="datepicker">
    <!--<input class="form-control" id="item-date" name="date" type="text" placeHolder="Date"/>-->
  </div>

  <div class="form-group">
    <label for="item-debut" class="control-label">Heure de début :</label>
    <input class="form-control" id="item-debut" name="debut" type="text" placeHolder="Heure de début"/>
  </div>

  <div class="form-group">
    <label for="item-fin" class="control-label">Heure de fin :</label>
    <input class="form-control" id="item-fin" name="fin" type="text" placeHolder="Heure de fin"/>
  </div>

  <button class="btn btn-success js-submit">Enregistrer</button>
</form>

package org.openlmis.contract_tests.requisition;

import static io.restassured.RestAssured.enableLoggingOfRequestAndResponseIfValidationFails;
import static io.restassured.RestAssured.given;
import static io.restassured.path.json.JsonPath.from;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.junit.Assert.assertThat;
import static org.openlmis.contract_tests.common.LoginStepDefs.ACCESS_TOKEN;
import static org.openlmis.contract_tests.common.TestVariableReader.baseUrlOfService;

import cucumber.api.DataTable;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.openlmis.contract_tests.common.InitialDataException;
import org.openlmis.contract_tests.common.TestDatabaseConnection;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RequisitionStepDefs {

  private Response requisitionResponse;
  private String requisitionId;
  private JSONObject requisition;
  private TestDatabaseConnection databaseConnection;

  private static final String BASE_URL_OF_REQUISITION_SERVICE =
      baseUrlOfService("requisition") + "requisitions/";

  private static final String ACCESS_TOKEN_PARAM_NAME = "access_token";

  static {
    enableLoggingOfRequestAndResponseIfValidationFails();
  }

  @Before
  public void setUp() throws InitialDataException {
    databaseConnection = new TestDatabaseConnection();
    //Because we have some initial data (bootstrap). We must remove it before loader.
    databaseConnection.removeData();
    databaseConnection.loadData();
  }

  @When("^I try to initiate a requisition with:$")
  public void tryToInitiateARequisition(DataTable argsList) {
    List<Map<String, String>> data = argsList.asMaps(String.class, String.class);
    for (Map map : data) {
      requisitionResponse = given()
          .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
          .queryParam("program", map.get("programId"))
          .queryParam("facility", map.get("facilityId"))
          .queryParam("suggestedPeriod", map.get("periodId"))
          .queryParam("emergency", map.get("emergency"))
          .when()
          .post(BASE_URL_OF_REQUISITION_SERVICE + "initiate");
    }
  }

  @Then("^I should get response with the initiated requisition's id$")
  public void shouldGetResponseWithTheInitiatedRequisitionId() {
    requisitionResponse
        .then()
        .body("id", notNullValue());
    requisitionId = from(requisitionResponse.asString()).get("id");
  }

  @When("^I try to get requisition with id$")
  public void tryToGetRequisitionWithId() {
    requisitionResponse = given()
        .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
        .when()
        .get(BASE_URL_OF_REQUISITION_SERVICE + requisitionId);
  }

  @Then("^I should get a requisition with:$")
  public void shouldGetRequisitionWith(DataTable argsList) {
    List<Map<String, String>> data = argsList.asMaps(String.class, String.class);
    for (Map map : data) {
      requisitionResponse
          .then()
          .body("program.id", is(map.get("programId")))
          .body("facility.id", is(map.get("facilityId")))
          .body("processingPeriod.id", is(map.get("periodId")))
          .body("emergency", is(Boolean.parseBoolean(String.valueOf(map.get("emergency")))));
    }
  }

  @When("^I try update fields in requisition:$")
  public void tryUpdateFieldsInRequisition(DataTable argsList) throws Throwable {

    if (requisition == null) {
      JSONParser parser = new JSONParser();
      Object object = parser.parse(requisitionResponse.asString());
      requisition = (JSONObject) object;
    }
    List<Map<String, String>> data = argsList.asMaps(String.class, String.class);

    for (Map map : data) {
      Map<String, String> hashMap = new HashMap<>(map);
      for (String fieldName : hashMap.keySet()) {
        updateFieldInRequisitionLineItem(requisition, fieldName, map.get(fieldName));
      }
    }

    requisitionResponse = given()
        .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
        .contentType(ContentType.JSON)
        .body(requisition.toJSONString())
        .when()
        .put(BASE_URL_OF_REQUISITION_SERVICE + requisitionId);
  }

  @Then("^I should get a updated requisition with:$")
  public void shouldGetUpdatedRequisition(DataTable argsList) throws ParseException {
    List<Map<String, String>> data = argsList.asMaps(String.class, String.class);
    JSONParser parser = new JSONParser();
    Object object = parser.parse(requisitionResponse.asString());
    JSONObject requisition = (JSONObject) object;
    Object requisitionLineItems = requisition.get(("requisitionLineItems"));
    JSONArray requisitionLines = (JSONArray) requisitionLineItems;

    int counter = 0;
    for (Map map : data) {
      Object oneLine = requisitionLines.get(counter);
      JSONObject requisitionLine = (JSONObject) oneLine;

      Map<String, String> hashMap = new HashMap<>(map);
      for (String fieldName : hashMap.keySet()) {
        assertThat(requisitionLine.get(fieldName).toString(), is(map.get(fieldName)));
      }
      counter++;
    }
  }

  @When("^I try to submit a requisition$")
  public void trySubmitRequisition() {
    requisitionResponse = given()
        .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
        .when()
        .post(BASE_URL_OF_REQUISITION_SERVICE + requisitionId + "/submit");
  }

  @Then("^I should get a requisition with \"([^\"]*)\" status$")
  public void shouldGetResponseWithTheRequisitionStatus(String status) {
    requisitionResponse
        .then()
        .body("status", is(status));
  }

  @When("^I try to authorize a requisition$")
  public void tryAuthorizeRequisition() {
    requisitionResponse = given()
        .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
        .when()
        .post(BASE_URL_OF_REQUISITION_SERVICE + requisitionId + "/authorize");
  }

  @When("^I try to approve a requisition$")
  public void tryApproveRequisition() {
    requisitionResponse = given()
        .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
        .when()
        .post(BASE_URL_OF_REQUISITION_SERVICE + requisitionId + "/approve");
  }

  @When("^I try to reject authorized requisition$")
  public void tryRejectRequisition() {
    requisitionResponse = given()
        .queryParam(ACCESS_TOKEN_PARAM_NAME, ACCESS_TOKEN)
        .when()
        .put(BASE_URL_OF_REQUISITION_SERVICE + requisitionId + "/reject");
  }

  private void updateFieldInRequisitionLineItem(JSONObject requisition,
                                                String keyToUpdate, Object newValue) {
    Object requisitionLineItems = requisition.get(("requisitionLineItems"));
    JSONArray requisitionLines = (JSONArray) requisitionLineItems;

    for (Object requisitionLine : requisitionLines) {
      JSONObject requisitionLineAsJson = (JSONObject) requisitionLine;
      requisitionLineAsJson.replace(keyToUpdate, newValue);
    }
  }

  @After
  public void cleanUp() throws InitialDataException {
    databaseConnection.removeData();
  }

}

Feature: Bill Payment P2G Test

  @gov
   #this is an integration for bill inquiry stage w/o rtp, includes bill inquiry api only from PFI to PBB to Bill Agg and back
  Scenario: BI-001 Bill Inquiry API for orchestration (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billInquiry" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "001"
    When I call the get bills api with billid with expected status of 202 and callbackurl as "/billInquiry"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for bill pay

  @gov
        #this is an integration for payment notification, includes api calls from PFI to PBB to Bill Agg and back (tests full flow)
  Scenario: BP-001 Bill Payments API for orchestration (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billNotification" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I have bill id as "001"
    And I generate clientCorrelationId
    And I can mock payment notification request
    When I call the payment notification api expected status of 202 and callbackurl as "/billNotification"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for bill notification


    #this is an integration for bill inquiry stage w/o rtp, includes bill inquiry api and payment notification from PFI to PBB to Bill Agg and back
  Scenario: Bill Inquiry API for orchestration (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billInquiry" endpoint for "POST" request with status of 200
    And I can register the stub with "/billNotification" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "001"
    When I call the get bills api with billid with expected status of 202 and callbackurl as "/billInquiry"
    Then I should get non empty response
    And I should get transactionId in response
    Given I have tenant as "gorilla"
    And I have bill id as "001"
    And I generate clientCorrelationId
    And I can mock payment notification request
    When I call the payment notification api expected status of 202 and callbackurl as "/billNotification"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    When I make the "POST" request to "/billNotification" endpoint with expected status of 200
    Then I should be able to extract response body from callback for bill pay
    When I make the "POST" request to "/billInquiry" endpoint with expected status of 200
    Then I should be able to extract response body from callback for bill pay

      #this is an component test for bill inquiry stage w/o rtp, includes bill inquiry api from PBB to Bill Agg with mock
      #response for bill inquiry api from Bill Agg to PBB to PFI
  Scenario: Bill Inquiry API for P2G (PBB to Biller/Agg)
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "001"
    When I call the mock get bills api from PBB to Biller with billid with expected status of 200
    Then I should get non empty response


   #this is an component test for bill inquiry stage w/o rtp, includes bill inquiry api from PBB to Bill Agg with mock
   #response for bill inquiry api from Bill Agg to PBB to PFI
  Scenario: Bill Payments API for P2G (PBB to Biller/Agg)
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "001"
    And I can mock payment notification request
    When I call the mock bills payment api from PBB to Biller with billid with expected status of 200
    Then I should get non empty response

  @gov
  Scenario: RTP Integration test
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/test" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I have a billerId as "GovBill"
    And I generate clientCorrelationId
    And I create a new clientCorrelationId
    Then I can create DTO for Biller RTP Request
    And I can call the biller RTP request API with expected status of 202 and "/test" endpoint
    Then I will sleep for 8000 millisecond
    And I can extract the callback body and assert the rtpStatus

  @gov
  Scenario: BI-002 Bill Inquiry API for orchestration fails due to invalid prefix (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billInquiry" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "101"
    When I call the get bills api with billid with expected status of 202 and callbackurl as "/billInquiry"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for biller unidentified

  @gov
  Scenario: BI-003A: Bill Inquiry API for orchestration fails due to invalid bill (PBB TO BA)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billInquiry" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "002"
    When I call the get bills api with billid with expected status of 202 and callbackurl as "/billInquiry"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for bill invalid

  @gov
  Scenario: BI-003B: Bill Inquiry API for orchestration fails due to payer fsp not onboarded (PFI TO PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billInquiryInvalid" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "003"
    When I call the get bills api with billid with expected status of 404 and callbackurl as "/billInquiryInvalid"
    Then I should get non empty response
    And I should get Payer FSP not found in response

  @gov
  Scenario: BI-004: Bill Inquiry API for orchestration fails due to empty bill (PBB TO BA)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billInquiryEmpty" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I create a new clientCorrelationId
    And I have bill id as "004"
    When I call the get bills api with billid with expected status of 202 and callbackurl as "/billInquiryEmpty"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for empty bill id

  @gov
  Scenario: BP-003 Bill Payments API fails due to mandatory fields missing (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billNotificationMissing" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I have bill id as "001"
    And I generate clientCorrelationId
    And I can mock payment notification request with missing values
    When I call the payment notification api expected status of 404 and callbackurl as "/billNotificationMissing"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for bill notification with missing values

  @gov
  Scenario: BP-004A Bill Payments API fails due to bill already marked paid (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billNotificationPaid" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I have bill id as "003"
    And I generate clientCorrelationId
    And I can mock payment notification request
    When I call the payment notification api expected status of 202 and callbackurl as "/billNotificationPaid"
    Then I should get non empty response
    And I should get transactionId in response
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for bill already paid

  @gov
  Scenario: BP-004B Bill Payments API fails due to bill marked as paid after a timeout (PFI to PBB)
    Given I can inject MockServer
    And I can start mock server
    And I can register the stub with "/billNotificationsTimeout" endpoint for "POST" request with status of 200
    Given I have tenant as "gorilla"
    And I have bill id as "005"
    And I generate clientCorrelationId
    And I can mock payment notification request
    When I call the payment notification api expected status of 202 and callbackurl as "/billNotificationsTimeout"
    Then I should get non empty response
    And I should get transactionId in response
    And I should remove all server events
    And I will sleep for 1000 millisecond
    Then I should not get a response from callback for bill
    And I will sleep for 5000 millisecond
    Then I should be able to extract response body from callback for bill paid after timeout
# BTCTicket

Areas for improvement:

* the GBPToBitcoin decodable data struct used by the view model is very restrictive at the moment. Creating a more dynamic model perhaps initialised using currency code would allow for greater flexibility and scalability.
* error handling - failed network requests are not handled. User could be shown an alert dialogue in cases of no network, error strings could be displayed instead of prices.
* handle poor network condition - display a loading overlay while waiting for network response.
* complete unit tests relating to the text fields and their interaction with each other - UI tests may be a better approach.
* test polling service - currently only test state after first network request.
* better organisation of view controller.
* give user a picker view to allow them to choose base currency - the initialiser for the network service would then need to take the currency code string as a parameter.
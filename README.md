# SerasaExperian

Serasa Experian makes it easier to perform company data checks on Serasa, providing methods that perform the query based on the parameters provided.

## Installation

1. **Add the gem to your project**
   Add the following line to your `Gemfile` and run `bundle install`:
   ```ruby
   gem "serasa_experian", git:"git@github.com:Null-Bug-Company/serasa-experian.git"
   ```

2. **Create initializer files**
   Run the generator to create the initializer file:
   ```bash
   rails generate serasa_experian:install
   ```
   After generating the initializer file, it is possible to configure environment variables to store fixed credentials. If an empty request is made that requires the clientID and clientSecret to be informed, the value informed in the environment variables will be used instead.
## Usage

### Authentication

To authenticate the user, create an instance of `SerasaExperian::Client` and call the `authentication` method, passing the client_id and client_secret as parameters.

#### Valid Attributes:
- **client_id**: clientID provided by Serasa itself for user authentication in the API. **Required**
- **client_secret**: clientSecret provided by Serasa itself for user authentication in the API. **Required**

#### Example:
```ruby
client = SerasaExperian::Client.new
client.create(client_id: 'exemple ID', client_secret: '123456')
```
---

### Report

To perform a query on Serasa-Experian, it is necessary to create an instance of `SerasaExperian::Company::Report` passing a client as a parameter and call the fetch method, passing the attributes necessary for the search.

##### Valid Attributes:
- **document**: The CNPJ that will be queried, which can be passed with or without formatting to perform the request. **Required**
- **report_name**: This is the name of the report that will be performed, which can be any of the three available in the manual provided by Serasa. **Required**
- **optional_features**: Name of the features chosen to perform the query, must be passed in array format separated by an empty space (" "). The name of the features must be consulted in the manual provided by Serasa.
- **report_parameters**: Some features require additional information to perform the query, this information must be passed in json format within an array. The gem itself will process this parameter to perform the query. The manual provided by Serasa must be consulted to verify which ones require this parameter.

##### Example:
```ruby
report_service = SerasaExperian::Companies::Report.new(client)
esponse = report_service.fetch(
        document: '12345678912345',
        report_name: 'RELATORIO',
        optional_features: ['EXEMPLO_1' 'EXEMPLO_2' 'EXEMPLO_3'],
        report_parameters: [       
          {
            "name": "NAME_EXEMPLE",
            "value": "EXAMPLE_123_VALUE"
          }
        ]
     )
```
---

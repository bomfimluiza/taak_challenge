public with sharing class TaakChallenge {
    
    public void basicAuthCallout(){
    	HttpRequest req = new HttpRequest();
    	req.setEndpoint('https://pokeapi.co/api/v2/pokemon');
    	req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        Http http = new Http();
     	HTTPResponse res = http.send(req);
     	System.debug(res.getBody());
        
  		JSONParser parser = JSON.createParser(res.getBody());
        List<ChallengeUser__c> pokeList = new List<ChallengeUser__c>();
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        ChallengeUserPokemon poke = (ChallengeUserPokemon)parser.readValueAs(ChallengeUserPokemon.class);
                        ChallengeUser__c p2 = new ChallengeUser__c(name = poke.name, url__c = poke.url);
                        pokeList.add(p2);
                        parser.skipChildren();
                    }
                }
            } else {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    ChallengeUserPokemon p = (ChallengeUserPokemon)parser.readValueAs(ChallengeUserPokemon.class);
                    System.debug('poke test: ' + p);
                    // Here I would get the previous and next values from the API
					// With those values I would be able to go page by page of the pagination
					// Once the next value is null I would know it was the last page and would finish my logic
                }
            }
        }
        
        // Here with all the pokemons added to the list I would insert them to the database
        // It would use only one insert making sure it would respect the governor limits
        System.debug('pokelist: ' + pokeList);
        insert pokeList;
    }
}
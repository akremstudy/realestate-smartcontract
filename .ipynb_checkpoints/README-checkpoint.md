# RealEstate Smart Contract

1) The courthouse will tokenize new properties being sold and keep record of all properties that are tokenized 

a) Add property (struct) - address, addr current owner, token id, property type, offer, ask, state

b) Keeping a count of properties added using mapping, token id will be the identifier for which property we are referring to

c) Function 1 - tokenize property done by courthouse 

2) Buyer/seller transactional relationship 

a) Function 2 - seller posts token for sale

b) Function 3 - buyer submits an offer 

3) If seller accepts offer (highest bid)then:

a) Function 4 - buyer submits initial deposit within 3 days 

b) Function 5 - proof of funds - buyer must submit proof of funds within 7 days

c) Function 6 - buyer pays in full and ether is transferred to seller immediately 0 

If statement (money is transferred then buyer becomes current owner and last price updates to purchase price). 

4) If offer is not accpeted then:

a) Transaction will end 

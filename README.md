# rubysol quick starter - run rubysol contracts (with 100%-solidity compatible data types & abis) in your own home for fun & profit (for free)


## What's Solidity?! What's Rubidity?! What's Rubysol?!

See [**Solidity - Contract Application Binary Interface (ABI) Specification** »](https://docs.soliditylang.org/en/latest/abi-spec.html)

See [**Rubidity - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity)

See [**Rubysol - Ruby for Layer 1 (L1) Contracts / Protocols with "Off-Chain" Indexer**  »](https://github.com/s6ruby/rubidity/tree/master/rubysol)


## Step 0 - Install Rubysol (Ruby Package)

``` ruby
gem install rubysol
```



##  Usage 

### Step 1 - Try Out Some Contracts

Let's try the PublicMintER20 Contract...

[contracts/public_mint_erc20.rb](/contracts/public_mint_erc20.rb):

``` ruby
class PublicMintERC20 < ERC20
  
  storage maxSupply:    UInt,
          perMintLimit: UInt 
  
  sig [String, String, UInt, UInt, UInt]
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals:
  ) 
    super( name: name, 
           symbol: symbol, 
           decimals: decimals)
 
    @maxSupply    = maxSupply
    @perMintLimit = perMintLimit
  end
 

  sig  [UInt]
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert( @totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  sig [Address, UInt]
  def airdrop( to:, amount: ) 
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert(@totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
```

that builds on the ERC20 (base) contract.

[contracts/erc20.rb](lib/rubidity/contracts/erc20.rb):

``` ruby
class PublicMintERC20 < ERC20
  
  storage maxSupply:    UInt,
          perMintLimit: UInt 
  
  sig [String, String, UInt, UInt, UInt]
  def constructor(
    name:,
    symbol:,
    maxSupply:,
    perMintLimit:,
    decimals:
  ) 
    super( name: name, 
           symbol: symbol, 
           decimals: decimals)
    
    @maxSupply    = maxSupply
    @perMintLimit = perMintLimit
  end
 

  sig  [UInt]
  def mint( amount: )
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert( @totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: msg.sender, amount: amount)
  end
  
  sig [Address, UInt]
  def airdrop( to:, amount: ) 
    assert(amount > 0, 'Amount must be positive')
    assert(amount <= @perMintLimit, 'Exceeded mint limit')
    
    assert(@totalSupply + amount <= @maxSupply, 'Exceeded max supply')
    
    _mint(to: to, amount: amount)
  end
end
```


Let's go.

``` ruby
require 'rubysol'

require_relative 'erc20'
require_relative 'public_mint_erc20'


contract = PublicMintERC20.new

contract.constructor(
    name: 'My Fun Token', # String,
    symbol: 'FUN',        # String,
    maxSupply:  21000000,  #  UInt,
    perMintLimit: 1000,    #  UInt,
    decimals:     18,      #  UInt
  ) 


contract.serialize
# {:name=>"My Fun Token",
#   :symbol=>"FUN",
#   :decimals=>18,
#   :totalSupply=>0,
#   :balanceOf=>{},
#   :allowance=>{},
#   :maxSupply=>21000000,
# :perMintLimit=>1000}

alice   = '0x'+'a'*40 # e.g. '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
bob     = '0x'+'b'*40 # e.g. '0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
charlie = '0x'+'c'*40 # e.g. '0xcccccccccccccccccccccccccccccccccccccccc'


#  sig [UInt]
#  def mint( amount: )
 contract.msg.sender = alice

contract.mint( 100 )
contract.mint( 200 )

contract.msg.sender = bob

contract.mint( 300 )
contract.mint( 400 )

#  sig [Address, UInt]
#  def airdrop( to:, amount: ) 
contract.airdrop( alice, 500 )
contract.airdrop( charlie, 600  )

contract.serialize
# {:name=>"My Fun Token",
#  :symbol=>"FUN",
#  :decimals=>18,
#  :totalSupply=>2100,
#  :balanceOf=>
#  {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>800,
#   "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>700,
#   "0xcccccccccccccccccccccccccccccccccccccccc"=>600},
# :allowance=>{},
# :maxSupply=>21000000,
# :perMintLimit=>1000}


#  sig [Address, UInt],  returns: Bool
#  def transfer( to:, amount: )
contract.transfer( alice, 1  )
contract.transfer( charlie, 2  )

#  sig [Address, UInt], returns: Bool
#  def approve( spender:, amount: ) 
contract.approve( alice, 11 )
contract.approve( charlie, 22 )


# sig [Address, Address, UInt], returns: Bool
# def transferFrom( from:, to:, amount:)
contract.msg.sender = alice

contract.approve( bob, 33 )

contract.transferFrom( bob, charlie, 3 )
contract.transferFrom( bob, alice, 4 )

contract.serialize
# {:name=>"My Fun Token",
#  :symbol=>"FUN",
#  :decimals=>18,
#  :totalSupply=>2100,
#  :balanceOf=> 
#  {"0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>805,
#   "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>690,
#   "0xcccccccccccccccccccccccccccccccccccccccc"=>605},
#  :allowance=>
#  {"0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=> {
#      "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=>4, 
#      "0xcccccccccccccccccccccccccccccccccccccccc"=>22},
#   "0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"=> {
#      "0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"=>33}},
# :maxSupply=>21000000,
# :perMintLimit=>1000}
```

And so on. That's it for now.






## Bonus - More Blockchain (Crypto) Tools, Libraries & Scripts In Ruby

See [**/blockchain**](https://github.com/rubycocos/blockchain) 
at the ruby code commons (rubycocos) org.


## Questions? Comments?

Join us in the [Rubidity & Rubysol (community) discord (chat server)](https://discord.gg/3JRnDUap6y). Yes you can.
Your questions and commentary welcome.

Or post them over at the [Help & Support](https://github.com/geraldb/help) page. Thanks.


######
# Let's try the PublicMintER20 Contacract...
require 'rubidity'

require_relative 'contracts/erc20'
require_relative 'contracts/public_mint_erc20'




contract = PublicMintERC20.new


contract.constructor( name: 'My Fun Token', 
                      symbol: 'FUN',       
                      maxSupply:  21000000,
                      perMintLimit: 1000,  
                      decimals:     18,    
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


# bye
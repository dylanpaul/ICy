import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Principal "mo:base/Principal";
import Reserve "canister:reserves";
import Float "mo:base/Float";
import User "canister:user";
import User1 "canister:user1";
import Text "mo:base/Text";
import Database "canister:database";
import Types "./types";


actor product{

//only keeps track of aCycle and aICP... token_outstanding put in reserves canister
    var aCycle_outstanding : Float = 0.0; //product balance of acycles created
    var aICP_outstanding : Float = 0.0;

    var icp_to_dollar : Float = 1.0; //this will change for now 1.0 for simplicity
    var cycle_to_dollar : Float = 1.0; //this will change for now 1.0 for simplicity
    var minRatio : Float = 2.0; //200%
    var interest: Float = 1.2; //20%

//require user to create account and add in however many tokens they want.
//this product canister will decrease and increase their balances accordingly.
//users will eventually be able to take their tokens out if they please to do so.
//this is because i dont know what token standrads there are and how to decerase
//tokens from a wallet/canister without importing that canister which is inefficient.


    //type Account = Types.Account;
    type UserId = Types.UserId;

//user must create account to utilize other functions (make this mandatory later on) 
    //public shared(msg) func create_account() : async (){
        //Database.createOne(msg.caller);
    //};

//user adding tokens to their account
    //public shared(msg) func add_cycles(amount : Float) : async (){
        //if(Principal.equal(msg.caller, User.get_id())){
            //User.decreaseCycles(amount);
        //};
        //Database.addCycles(msg.caller, amount);
    //};

//getter functions for product canister
    public func icp_tokenbalance(): async Float {
        let icp_token_outstanding = await Reserve.icp_balance();
        return icp_token_outstanding;
    };

    public func cycle_tokenbalance(): async Float {
        let cycle_token_outstanding = await Reserve.cycles_balance();
        return cycle_token_outstanding;
    };

    public func aICP_balance(): async Float {
        return aICP_outstanding;
    };

    public func aCycle_balance(): async Float {
        return aCycle_outstanding;
    };



//utilizing reserve canister!!

//now making functions called from product canister... users interact with the product canister
// to deposit, redeem, borrow, repay. Acts as lending pool smart contract like in AAVE
//at the moment still using imports from user canisters... works for only 2 user canisters
//add userID back in as argument eventually. Deposits and redeeming!
    public shared(msg) func deposit(userId: Text, token_name : Text, amount : Float) : async (Text, Bool){
        
        //for user canister
        if(Text.equal(userId, "User")){
            //for deposit cycle_token
            if(Text.equal(token_name, "cycle_token")){
                let cycle_user = await User.cycle_tokenbalance();
                if(amount <= cycle_user){
                    let temp = await User.decreaseCycles(amount); 
                    let temp1 = await Reserve.increaseAvailCycles(amount);
                    //minting
                    aCycle_outstanding += amount;
                    let temp2 = await User.increaseACycles(amount);
                    return ("Success", true);
                };
            return ("Failure: amount is more than your balance of cycles", false);
            };

            //for deposit icp_token
            if(Text.equal(token_name, "icp_token")){
                let icp_user = await User.icp_tokenbalance();
                if(amount <= icp_user){
                    let temp = await User.decreaseICP(amount);
                    let temp1 = await Reserve.increaseAvailICP(amount);
                    //minting
                    aICP_outstanding += amount;
                    let temp2 = await User.increaseAICP(amount);
                    //eventually include a fixed interest rate to multiply by
                    return ("Success", true);
                };
                return ("Failure: amount is more than your balance of ICP", false);
            };

            //for redeeming cycle_token
            if(Text.equal(token_name, "aCycle")){
                let acycle_users = await User.aCycle_balance();
                if(amount <= acycle_users){
                    let temp = await User.decreaseACycles(amount);
                    let temp1 = await Reserve.decreaseAvailCycles(amount);
                    //burning
                    aCycle_outstanding -= amount;
                    let temp2 = await User.increaseCycles(amount); //eventually include a fixed interest rate to multiply by
                    return ("Success", true);
                };
                return ("Failure: amount is more than your balance of ICP", false);
            };

            //for redeeming ICP_token
            if(Text.equal(token_name, "aICP")){
                let aICP_user = await User.aICP_balance();
                if(amount <= aICP_user){
                    let temp = await User.decreaseAICP(amount);
                    let temp1 = await Reserve.decreaseAvailICP(amount);
                    //burning
                    aICP_outstanding -= amount;
                    let temp2 = await User.increaseICP(amount); //eventually include a fixed interest rate to multiply by
                    return ("Success", true);
                };
            };
            return ("Failure - Something went wrong for User: check balance of token", false);
        };
        


 ///////////////for user1 canister
        if(Text.equal(userId, "User1")){
            //for deposit cycle_token
            if(Text.equal(token_name, "cycle_token")){
                let cycle_user = await User1.cycle_tokenbalance();
                if(amount <= cycle_user){
                    let temp = await User1.decreaseCycles(amount); 
                    let temp1 = await Reserve.increaseAvailCycles(amount);
                    //minting
                    aCycle_outstanding += amount;
                    let temp2 = await User1.increaseACycles(amount);
                    return ("Success", true);
                };
            return ("Failure: amount is more than your balance of cycles", false);
            };

            //for deposit icp_token
            if(Text.equal(token_name, "icp_token")){
                let icp_user = await User1.icp_tokenbalance();
                if(amount <= icp_user){
                    let temp = await User1.decreaseICP(amount);
                    let temp1 = await Reserve.increaseAvailICP(amount);
                    //minting
                    aICP_outstanding += amount;
                    let temp2 = await User1.increaseAICP(amount);
                    //eventually include a fixed interest rate to multiply by
                    return ("Success", true);
                };
                return ("Failure: amount is more than your balance of ICP", false);
            };

            //for redeeming cycle_token
            if(Text.equal(token_name, "aCycle")){
                let acycle_users = await User1.aCycle_balance();
                if(amount <= acycle_users){
                    let temp = await User1.decreaseACycles(amount);
                    let temp1 = await Reserve.decreaseAvailCycles(amount);
                    //burning
                    aCycle_outstanding -= amount;
                    let temp2 = await User1.increaseCycles(amount); //eventually include a fixed interest rate to multiply by
                    return ("Success", true);
                };
                return ("Failure: amount is more than your balance of ICP", false);
            };

            //for redeeming ICP_token
            if(Text.equal(token_name, "aICP")){
                let aICP_user = await User1.aICP_balance();
                if(amount <= aICP_user){
                    let temp = await User1.decreaseAICP(amount);
                    let temp1 = await Reserve.decreaseAvailICP(amount);
                    //burning
                    aICP_outstanding -= amount;
                    let temp2 = await User1.increaseICP(amount); //eventually include a fixed interest rate to multiply by
                    return ("Success", true);
                };
            };
            return ("Failure - Something went wrong for User1: check balance of token", false);
        };
        return ("Failure - Something went wrong: check balance of token", false);
    };


//function for borrowing
//add userID back in as argument eventually
    public func borrow(userId: Text, token_name : Text, amount : Float) : async (Text, Bool){
        //for user canister
        if(Text.equal(userId, "User")){
            //for borrowing cycle_token
            if((Text.equal(token_name, "cycle_token"))){
                //checks if meets collateral ratio
                let aicp_user = await User.aICP_balance();
                if(((aicp_user * icp_to_dollar) / (amount * cycle_to_dollar)) >= minRatio){
                    let temp = await User.increaseCycles(amount);
                    let temp1 = await Reserve.lockICP(minRatio * amount * cycle_to_dollar);
                    let sendback = await User.decreaseAICP(amount * minRatio);//user sends aICP to product
                    aICP_outstanding += (amount * minRatio); 
                    //for now just lock minRatio * amount so just lock up bare minimum to borrow (eventually it will be based off how much you want to borrow and health factor)
                    let temp2 = await Reserve.decreaseAvailCycles(amount);
                    return ("Success", true);
                };
                    return ("Failure - Borrow less cycles or Deposit more ICP.", false);
            };

            //for borrowing icp_token
            if((Text.equal(token_name, "icp_token"))){
                //checks if meets collateral ratio
                let acycle_user = await User.aCycle_balance();
                if(((acycle_user * cycle_to_dollar) / (amount * icp_to_dollar)) >= minRatio){        
                    let temp = await User.increaseICP(amount);
                    let temp1 = await Reserve.lockCycles(minRatio * amount * cycle_to_dollar); //cycles cant be borrowed by others because user is using as collateral
                    let sendback = await User.decreaseACycles(amount * minRatio);//user sends acycles to product so cant earn interest
                    aCycle_outstanding += (amount * minRatio); //increase product acycles 
                    let temp2 = await Reserve.decreaseAvailICP(amount);
                    return ("Success", true);
                };
                return ("Failure - Borrow less ICP or Deposit more cycles.", false);
            };
            return ("Failure - Something went wrong for User: check name of token", false);
        };


        ////for user1 canister
        if(Text.equal(userId, "User1")){
            //for borrowing cycle_token
            if((Text.equal(token_name, "cycle_token"))){
                //checks if meets collateral ratio
                let aicp_user = await User1.aICP_balance();
                if(((aicp_user * icp_to_dollar) / (amount * cycle_to_dollar)) >= minRatio){
                    let temp = await User1.increaseCycles(amount);
                    let temp1 = await Reserve.lockICP(minRatio * amount * cycle_to_dollar); //lock as collateral
                    let sendback = await User1.decreaseAICP(amount * minRatio);//user sends aICP to product
                    aICP_outstanding += (amount * minRatio);
                    //for now just lock minRatio * amount so just lock up bare minimum to borrow (eventually it will be based off how much you want to borrow and health factor)
                    let temp2 = await Reserve.decreaseAvailCycles(amount);
                    return ("Success", true);
                };
                    return ("Failure - Borrow less cycles or Deposit more ICP.", false);
            };

            //for borrowing icp_token
            if((Text.equal(token_name, "icp_token"))){
                //checks if meets collateral ratio
                let acycle_user = await User1.aCycle_balance();
                if(((acycle_user * cycle_to_dollar) / (amount * icp_to_dollar)) >= minRatio){        
                    let temp = await User1.increaseICP(amount);
                    let sendback = await User1.decreaseACycles(amount * minRatio);//user sends acycles to product
                    aCycle_outstanding += (amount * minRatio); //increase product acycles
                    let temp1 = await Reserve.lockCycles(minRatio * amount * cycle_to_dollar); 
                    let temp2 = await Reserve.decreaseAvailICP(amount);
                    return ("Success", true);
                };
                return ("Failure - Borrow less ICP or Deposit more cycles.", false);
            };
        return ("Failure - Something went wrong for User: check name of token", false);
        };
    return ("Failure - Something went wrong: check balance of token", false);
    };

    

    //repay loan
    public func repay(userId: Text, token_name : Text, amount : Float) : async (Text, Bool){
        
        //For user canister
        if(Text.equal(userId, "User")){
            //want to get back aICP so must repay cycles
            if(Text.equal(token_name, "cycle_token")){
                    let cycle_users = await User.cycle_tokenbalance();
                    if(amount <= cycle_users){
                        let temp = await User.decreaseCycles(amount);
                        let temp1 = await Reserve.increaseAvailCycles(amount); //cycles given back
                        let unlock = await Reserve.unlockICP(amount);    //unlock reserve ICP not used for collateral anymore and can be borroed by others
                        aICP_outstanding -= ((amount/interest)*minRatio); //product gives back to user less than 1:1 bc of interest
                        let temp2 = await User.increaseAICP((amount/interest)*minRatio); //user balance only increases by amount repaid/interest times the minratio to get locked up back
                        return ("Success", true);
                    };
                    return ("Failure: amount is more than your balance of ICP", false);
            };
        

            //want to get back aCycles so must repay ICP
            if(Text.equal(token_name, "icp_token")){
                let icp_users = await User.icp_tokenbalance();
                    if(amount <= icp_users){
                        let temp = await User.decreaseICP(amount);
                        let temp1 = await Reserve.increaseAvailICP(amount); //cycles given back
                        let unlock = await Reserve.unlockCycles(amount);    //unlock reserve cycles not used for collateral anymore and can be borroed by others
                        aCycle_outstanding -= ((amount/interest)*minRatio); //product gives back to user less than 1:1 bc of interest
                        let temp2 = await User.increaseACycles((amount/interest)*minRatio); //user balance only increases by amount repaid/interest
                        return ("Success", true);
                    };
                    return ("Failure: amount is more than your balance of ICP", false);
            };
            return ("Failure - Something went wrong for User: check name of token", false);
        };


        //For User1 canister
         if(Text.equal(userId, "User1")){
            //want to get back aICP so must repay cycles
            if(Text.equal(token_name, "cycle_token")){
                    let cycle_users = await User1.cycle_tokenbalance();
                    if(amount <= cycle_users){
                        let temp = await User1.decreaseCycles(amount);
                        let temp1 = await Reserve.increaseAvailCycles(amount); //cycles given back
                        let unlock = await Reserve.unlockICP(amount);    //unlock reserve ICP not used for collateral anymore and can be borroed by others
                        aICP_outstanding -= ((amount/interest)*minRatio); //product gives back to user less than 1:1 bc of interest
                        let temp2 = await User1.increaseAICP((amount/interest)*minRatio); //user balance only increases by amount repaid/interest
                        return ("Success", true);
                    };
                    return ("Failure: amount is more than your balance of ICP", false);
            };
        

            //want to get back aCycles so must repay ICP
            if(Text.equal(token_name, "icp_token")){
                let icp_users = await User1.icp_tokenbalance();
                    if(amount <= icp_users){
                        let temp = await User1.decreaseICP(amount);
                        let temp1 = await Reserve.increaseAvailICP(amount); //cycles given back
                        let unlock = await Reserve.unlockCycles(amount);    //unlock reserve cycles not used for collateral anymore and can be borroed by others
                        aCycle_outstanding -= ((amount/interest)*minRatio); //product gives back to user less than 1:1 bc of interest
                        let temp2 = await User1.increaseACycles((amount/interest)*minRatio); //user balance only increases by amount repaid/interest
                        return ("Success", true);
                    };
                    return ("Failure: amount is more than your balance of ICP", false);
            };
            return ("Failure - Something went wrong for User: check name of token", false);
        };
        return ("Failure - Something went wrong: check balance of token", false);
    };

};

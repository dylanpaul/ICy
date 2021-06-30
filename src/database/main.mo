import Nat "mo:base/Nat";
import User "canister:user";
import Text "mo:base/Text";
import Float "mo:base/Float";
import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Types "./typess";
import List "mo:base/List";

actor database {
    /*
    //type NewAccount = Types.NewAccount;
    type Account = Types.Account;
    type UserId = Types.UserId;
    type Arrays = Array;

    //let x : [var Nat] = Array.init<Nat>(size, 3);

    func isEq(x: UserId, y: UserId): Bool { x == y };
  
    // The "database" is just a local hash map
    var hashMap = HashMap.HashMap<UserId, Account>(1, isEq, Principal.hash);
    //the "database" is just a local hash map(value is a list or array) (tokens are always indexed 0: ICP, 1: cycles, 2: aICP, 3:aCycles)
    var hashMap1 = HashMap.HashMap<UserId, Arrays>(1, isEq, Principal.hash);

    public func createOne(userId: UserId) {
        hashMap.put(userId, makeAccount(userId));
        hashMap1.put(userId, makeAccount1(userId));
    };

    //public func addCycles(userId: UserId, amount: Float) {
        //if(userId )
        //var a : Account = hashMap.get(userId);
        //a.cycles += amount;
        //hashMap.replace(userId, a);
    //};

    public func findOne(userId: UserId): async ?Account {
        hashMap.get(userId);
    };
    
//initializes account to 0 balance until canister puts in funds
    func makeAccount(userId: UserId): Account {
        {
            id = userId;
            icp = 0;
            cycles = 0;
            aICP = 0;
            aCycles = 0;
        }
    };

    func makeAccount1(userId: UserId) : Array {
        let a : [var Float] = [var 0, 0, 0, 0] ;
    }

   */
};

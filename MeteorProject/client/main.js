import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.html';

Template.hello.onCreated(function helloOnCreated() {
  // counter starts at 0
  this.counter = new ReactiveVar(0);
});

Template.hello.helpers({
  counter() {
    return Template.instance().counter.get();
  },
});

Template.hello.events({
  'click button'(event, instance) {
    // increment the counter when button is clicked
    instance.counter.set(instance.counter.get() + 1);
  },
});

Template.info.onCreated(function() {
  var template = this;
  web3.eth.getAccounts(function(err, res){
      TemplateVar.set(template, "account", res[0]);
      web3.eth.getBalance(res[0], function(err, res){
        TemplateVar.set(template, "balance", res)
    });
  });
  myContract.num(function (err, res) {
    TemplateVar.set(template, "num", res);
  });
});

Template.info.events({
  'click button'(event, instance) {
    let template = Template.instance();
    // syncFunc = Meteor._wrapAsync(myContract.bet);
    // res = syncFunc();
    // console.log(res);
    myContract.bet(function(err, res) {
      alert(res);
    })
  }
})

const contractAddress = "0xb80CCc6Ea79d357D9Eae44784b20987040fff506";

const contractABI = [
	{
		"constant": false,
		"inputs": [],
		"name": "bet",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "num",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
];

const myContract = web3.eth.contract(contractABI).at(contractAddress);



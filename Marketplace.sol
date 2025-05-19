 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    struct Product {
        uint id;
        string name;
        uint price;
        address payable owner;
        bool sold;
    }

    uint public productCount = 0;
    mapping(uint => Product) public products;

    event ProductListed(uint id, string name, uint price, address owner);
    event ProductBought(uint id, address buyer);

    function listProduct(string memory _name, uint _price) public {
        productCount++;
        products[productCount] = Product(productCount, _name, _price, payable(msg.sender), false);
        emit ProductListed(productCount, _name, _price, msg.sender);
    }

    function buyProduct(uint _id) public payable {
        Product storage product = products[_id];
        require(!product.sold, "Already sold");
        require(msg.value >= product.price, "Not enough ETH");

        product.owner.transfer(msg.value);
        product.sold = true;

        emit ProductBought(_id, msg.sender);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleToken
 * @dev A simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `ERC20` functions.
 */
contract SimpleToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Constructor that gives `msg.sender` all of existing tokens.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _decimals The number of decimals the token uses.
     * @param _initialSupply The initial supply of tokens.
     * @param _owner The address of the owner who will receive the initial supply.
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply,
        address _owner
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint256(_decimals);
        balanceOf[_owner] = totalSupply;
        emit Transfer(address(0), _owner, totalSupply);
    }

    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     * @return success A boolean that indicates if the operation was successful.
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
}

/**
 * @title TokenFactory
 * @dev Factory contract for creating new SimpleToken contracts.
 * This contract demonstrates the Factory Pattern, which is used to create instances of other contracts.
 */
contract TokenFactory {
    address[] public deployedTokens;

    /**
     * @dev Emitted when a new token is created.
     * @param tokenAddress The address of the newly created token contract.
     * @param owner The address of the owner of the newly created token.
     */
    event TokenCreated(address indexed tokenAddress, address indexed owner);

    /**
     * @dev Creates a new SimpleToken contract and stores its address.
     * This function demonstrates the Factory Pattern by creating new instances of the SimpleToken contract.
     * @param _name The name of the token.
     * @param _symbol The symbol of the token.
     * @param _decimals The number of decimals the token uses.
     * @param _initialSupply The initial supply of tokens.
     */
    function createToken(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _initialSupply
    ) public {
        /// @dev Create a new token contract
        SimpleToken newToken = new SimpleToken(
            _name,
            _symbol,
            _decimals,
            _initialSupply,
            msg.sender
        );
        deployedTokens.push(address(newToken));
        emit TokenCreated(address(newToken), msg.sender);
    }

    /**
     * @dev Returns the list of all deployed token addresses.
     * @return An array of addresses of the deployed token contracts.
     */
    function getDeployedTokens() public view returns (address[] memory) {
        return deployedTokens;
    }
}
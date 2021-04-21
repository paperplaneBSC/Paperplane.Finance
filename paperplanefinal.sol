///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                           //
//                                  WELCOME TO PAPERPLANE.FINANCE                                            //
//                                                                                                           //
//  This token has some unique features. There is a 13% tx fee on every tx. This fee is a 12%                //
//  (burn+redistribution+liquidityTokens) part (more on this later) and a 1% marketing fee.                  //
//                                                                                                           //
//  Team doesnt have any tokens at all. Our presale estrategy is 76% of tokens are for                       //
//  presale+initial liquidity and the remaining 24% stays within the contract to add LP over time            //
//                                                                                                           //
//                            THERE IS 0% TOKENS FOR TEAM AT THE BEGINING.                                   //
//                                                                                                           //
//  The 12% fee part is a variable sum of redistribution burn and tokens for more LP. Each % varies          //
//  depending on the size of the sender wallet. EVERYONE PAYS 12%. But PaperWhales Redistribute more and     //
//  burn less. Meanwhile PaperHands (Diamond Heart) redistribute a little and burn MOAR! The total fee       //
//                                 IS THE SAME FOR EVERYONE 12%                                              //
//                                                                                                           //
//  This is only the first phase of Paperplane.finance. We have many plans for the future.                   //
//                                                                                                           //
//                                          SOCIALS                                                          //
//                  Website:      https://paperplane.finance/                                                //                                
//                  Twitter:      https://twitter.com/PaperplaneBSC                                          //
//                  Medium:       https://medium.com/@paperplanebsc                                          //
//                  GitHub:       https://github.com/paperplaneBSC                                           //
//                  Telegram:     https://t.me/paperplanefinance                                             //
//                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Address {

    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until some time passes");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}



// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract PaperPlane is Context, IERC20, Ownable {
    using Address for address;


    //addresses Burn, Marketing, Lp Wallet
    address private constant _burnAddress = 0x000000000000000000000000000000000000dEaD;
    address private _marketingWallet = 0x000000000000000000000000000000000000dEaD; // to be change to marketingWallet at begining before deploy
    address private _lpWallet = _marketingWallet;

    //MAPINGS
    //mapping balance and reflected balance of address
    mapping (address => uint256) private _balances;
    mapping (address => uint256) private _reflectBalances;

    //allowances of address to address with amount about this token
    mapping (address => mapping (address => uint256)) private _allowances;

    //mapping who is excluded from what (Fees or recieve Rewards)
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcludedFromReward;
    address[] private _excludedFromReward;

    //PROJECT SETTINGS
    //Name Symbol Decimals
    string private constant _name = 'Paperplane.finance'; // to be determined
    string private constant _symbol = 'PPLANE'; // to be determined
    uint8 private constant _decimals = 18;

    //Supply and Reflected Supply and other options
    uint256 private constant _decimalFactor = 10**uint256(_decimals);
    uint256 private _tokenTotal = 10000000 * _decimalFactor ;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _reflectedTotal = (MAX - (MAX % _tokenTotal));
    uint256 private constant _granularity = 100; // this allows 0.5 percentages for example
    uint256 private _totalTokenFee = 0;
    
    //Total Fees collected
    uint256 private _totalMarketing;
    uint256 private _totalBurn;
    uint256 private _totalLiq;

    //Initial fees
    uint256 private aMulti = 1000; //aMulti + 2*bMulti must add 1200
    uint256 private bMulti = 100; //aMulti + 2*bMulti must add 1200
    uint256 private _tokensToLP = 5000 * _decimalFactor;  //0.5% of total supply
    uint256 private marketingFee = 100; // multiplier 1 (100/100)



    

    //Router and Pair Addresses for Add Liquidity
    IUniswapV2Router02 private immutable uniswapV2Router;
    address private immutable uniswapV2Pair;
    IUniswapV2Pair private immutable pair;
    
    //Add Liquidity checkeers

    bool private inSwapAndLiquify;
    bool private swapAndLiquifyEnabled = false; // to be set true as soon as possible
    //eventos
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    event Info(string cad, uint256 num);

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    constructor () {
        //trial!!
        uint256 initial = (_reflectedTotal / 100);
        _reflectBalances[_msgSender()] = initial*76; // listing price 40000 tokens per BNB presale+liq. 7.600.000 tokens
        //prueba estas dos!!
        _reflectBalances[address(this)] = initial*24; // tokens for liq over time. 2.400.000 tokens
        _balances[address(this)] = tokenFromReflection( _reflectBalances[address(this)]);

        //real pancake router
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
        //testnet router
        //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
         // Create a uniswap pair for this new token
        IUniswapV2Factory factory = IUniswapV2Factory(_uniswapV2Router.factory());
        uniswapV2Pair = factory.createPair(address(this), _uniswapV2Router.WETH());
        pair = IUniswapV2Pair(factory.getPair(address(this),  _uniswapV2Router.WETH()));
        
        //uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
        //    .createPair(address(this), _uniswapV2Router.WETH());
        
        uniswapV2Router = _uniswapV2Router;


        //exclude owner, this contract, Burn, Marketing and Lp addresses from paying fees
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        //_isExcludedFromFee[_burnAddress] = true;
        _isExcludedFromFee[_marketingWallet] = true;
        _isExcludedFromFee[_lpWallet] = true;
        
        //exclude addresses from recieving reflection
        //_isExcludedFromReward[uniswapV2Pair] = true; // PCS pair address dont get redist as that would impact the price down.
        _isExcludedFromReward[address(this)] = true; // we dont need reflection as we get liquidityfee and we will be big owner at beggining(contract address)! gud for rest holders
        _isExcludedFromReward[_burnAddress] = true;
        
        
        emit Transfer(address(0), _msgSender(), initial*76);
        emit Transfer(address(0), address(this), initial*24);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _tokenTotal;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        if (_isExcludedFromReward[account]) return _balances[account];
        return tokenFromReflection(_reflectBalances[account]);
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        return true;
    }

    
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (
            balanceOf(address(this)) >= _tokensToLP &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair && //why only when selling??
            swapAndLiquifyEnabled
        ) {
            swapAndLiquify(_tokensToLP);
        }
        
        (uint256 rf,uint256 bf,uint256 lpf,uint256 mf) = getTransferFee(sender, recipient);
        _transferTakingOutFees(sender, recipient, amount, rf+bf+lpf+mf);
        _takeLiqBurnMark(sender,amount,rf,bf,lpf,mf);
    }

    function _transferTakingOutFees(address sender, address recipient, uint256 tokenAmount, uint256 totalFee) private {
        uint256 currentRate =  _getRate();
        uint256 totalTokenFee = (((tokenAmount * totalFee) / _granularity )/ 100);
        uint256 tTransferAmount = tokenAmount - totalTokenFee;
        _reflectBalances[sender] -= tokenAmount*currentRate;
        _reflectBalances[recipient] += tTransferAmount*currentRate;
        if(_isExcludedFromReward[sender]) 
            _balances[sender] -= tokenAmount ;
        if(_isExcludedFromReward[recipient]) 
            _balances[recipient] += tTransferAmount;
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _takeLiqBurnMark(address sender, uint256 tokenAmount, uint256 reff, uint256 burnf, uint256 liqf, uint256 markf) private {
        uint256 totalFee =  reff+burnf+liqf+markf;
        uint256 currentRate =  _getRate();
        uint256 totalTokenFee = (((tokenAmount * totalFee) / _granularity )/ 100);
        if (totalFee != uint256(0)){
            uint256 tBurn = (totalTokenFee/totalFee)*burnf;
            uint256 tRef = (totalTokenFee/totalFee)*reff;
            uint256 tMark =  (totalTokenFee/totalFee)*markf;
            uint256 tLiq = totalTokenFee-tRef-tBurn-tMark;
            _reflectedTotal -= tRef*currentRate;
            _genericTransferFee(sender, _burnAddress,tBurn,tBurn*currentRate);
            _genericTransferFee(sender,address(this),tLiq,tLiq*currentRate);
            _genericTransferFee(sender, _marketingWallet,tMark,tMark*currentRate);
        }     
    }

    function _genericTransferFee (address sender, address recipient, uint256 tFeeGeneric, uint256 rFeeGeneric) private{
        if (tFeeGeneric == 0) return;
        _reflectBalances[recipient] +=rFeeGeneric;
        if(_isExcludedFromReward[recipient])
            _balances[recipient] += tFeeGeneric;
        _totalTokenFee += tFeeGeneric;
		emit Transfer(sender, recipient, tFeeGeneric);
    }
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }


    function swapAndLiquify(uint256 tokensToAddToLp) private lockTheSwap {
        // split the contract balance into halves
        uint256 half = tokensToAddToLp / 2;

        // swap tokens for ETH
        swapTokensForEth(half); // <- this breaks the ETH -> PPLANE swap when swap+liquify is triggered
        addLiquidity(balanceOf(address(this)), address(this).balance );
        //emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            _lpWallet, // LP WALLET HERE OR OWNER()
            block.timestamp
        );
    }

    receive() external payable {} //IMPORTANT!! TO BE ABLE TO RECIEVE BNB!!!

    function tokenFromReflection(uint256 reflectedAmount) public view returns(uint256) {
        require(reflectedAmount <= _reflectedTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return reflectedAmount / currentRate ;
        //return reflectedAmount.div(currentRate);
    }

    function _getRate() private view returns(uint256) {
        (uint256 reflectedSupply, uint256 tokenSupply) = _getCurrentSupply();
        return reflectedSupply / tokenSupply ;
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 reflectedSupply = _reflectedTotal;
        uint256 tokenSupply = _tokenTotal;      
        for (uint256 i = 0; i < _excludedFromReward.length; i++) {
            if (_reflectBalances[_excludedFromReward[i]] > reflectedSupply || _balances[_excludedFromReward[i]] > tokenSupply) return (_reflectedTotal, _tokenTotal);
            reflectedSupply = reflectedSupply- _reflectBalances[_excludedFromReward[i]];
            tokenSupply = tokenSupply-_balances[_excludedFromReward[i]];
        }
        if (reflectedSupply < (_reflectedTotal /tokenSupply) ) return (_reflectedTotal, _tokenTotal);
        return (reflectedSupply, tokenSupply);
    }

    function getTransferFee(address sender, address recipient) private view returns (uint256, uint256 , uint256 , uint256) {
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
            return (uint256(0),uint256(0),uint256(0),uint256(0));
        }
        uint256 balance = balanceOf(sender);
        uint256 rf = 400;
        uint256 bf = 400;
        uint256 lpf = 400;
        if (balance > _tokenTotal/20){ // >500.000 PPLANE
            rf =  aMulti; // 10%
            bf =  bMulti; // 1%
            lpf = bMulti; // 1%
        }else if (balance > _tokenTotal/90){ // >111.111 PPLANE
            rf =  aMulti-200; // 10% - 2% -> 8%
            bf =  bMulti+100; // 1% + 1% -> 2%
            lpf = bMulti+100; // 1% + 1% -> 2%
        }else if (balance > _tokenTotal/160){ // >62.500 PPLANE
            rf =  aMulti-400; // 10% - 4% -> 6%
            bf =  bMulti+200; // 1% + 2% -> 3%
            lpf = bMulti+200; // 1% + 2% -> 3%
        }else if (balance > _tokenTotal/320){ // >31.250 PPLANE
            rf =  bMulti+200; // 1% + 2% -> 3%
            bf =  aMulti-400; // 10% - 4% -> 6%
            lpf = bMulti+200; // 1% + 2% -> 3%
        }else if (balance > _tokenTotal/640){ // >15.625 PPLANE
            rf =  bMulti+100; // 1% + 1% -> 2%
            bf =  aMulti-200; // 10% - 2% -> 8%
            lpf = bMulti+100; // 1% + 1% -> 2%
        }else { // =<15.625 PPLANE
            rf =  bMulti; // 1%
            bf =  aMulti; // 10%
            lpf = bMulti; // 1%
        }
        return(rf,bf,lpf,marketingFee);
    }

    function giveReflect(uint256 tokenAmount) public {
        address sender = _msgSender();
        require(!_isExcludedFromReward[sender], "Excluded addresses cannot call this function");
        uint256 currentRate =  _getRate();
        uint256 reflectAmount = tokenAmount*currentRate;
        _reflectBalances[sender] -= reflectAmount;
        _reflectedTotal -= reflectAmount;
        emit Transfer(sender, 0x0000000000000000000000000000000000000000, tokenAmount);
    }

    function giveReflectFromContract(uint256 tokenAmount) private onlyOwner {
        uint256 currentRate =  _getRate();
        uint256 reflectAmount = tokenAmount*currentRate;
        _reflectBalances[address(this)] -= reflectAmount;
        _balances[address(this)] -= tokenAmount;
        _reflectedTotal -= reflectAmount;
        emit Transfer(address(this), 0x0000000000000000000000000000000000000000, tokenAmount);
    }



    //Getters
    function getTotalTaxedFees() public view returns(uint256){
        return _totalTokenFee;
    }

    function getPairAddress() public view returns(address){
        return uniswapV2Pair;
    }

    function getMarketingInfo() public view returns(address,uint256){
        return (_marketingWallet,marketingFee);
    }

    function getLpInfo() public view returns(address){
        return _lpWallet;
    }

    function getFeeInfo() public view returns(uint256,uint256,uint256){
        return (aMulti,bMulti,marketingFee);
    }

    function getNumTokensToLP() public view returns(uint256){
        return _tokensToLP;
    }

    function isExcludedFromFee(address account) public view returns(bool){
        return _isExcludedFromFee[account];
    }

    function isExcludedFromReward(address account) public view returns(bool){
        return _isExcludedFromReward[account];
    }

    function isSwapAndLiquifyEnabled() public view returns(bool){
        return swapAndLiquifyEnabled;
    }

    function getSupply() public view returns(uint256,uint256){
        return _getCurrentSupply();
    }

    //Setters

    function setNumberTokensToLP(uint256 amount) public onlyOwner{
        require(amount>_decimalFactor);
        _tokensToLP = amount;
    }

    function setLpWallet(address account) public onlyOwner{
        includeInFees(_lpWallet);
        _lpWallet = account;
        excludeFromFees(_lpWallet);
    }

    function setMarkWallet(address account) public onlyOwner{
        includeInFees(_marketingWallet);
        _marketingWallet = account;
        excludeFromFees(_marketingWallet);
    }

    function setFees(uint256 multA, uint256 multB, uint256 mark) public onlyOwner{
        require (mark<uint256(100) && mark >= uint(0));
        require (multA+(2*multB)==uint256(1200) && multA>=uint256(400));
        aMulti = multA;
        bMulti = multB;
        marketingFee = mark;
    }
    
    function setMarkFeeMult(uint256 mult) public onlyOwner{
        require (mult<uint256(100) && mult >= uint(0));
        marketingFee = mult;
    }

    function excludeFromFees(address account) public onlyOwner{
        _isExcludedFromFee[account] = true;
    }

    
    function includeInFees(address account) public onlyOwner{
        _isExcludedFromFee[account] = false;
    }

    function excludeFromReward(address account) public onlyOwner {
        require(!_isExcludedFromReward[account], "Account is already excluded");
        if(_reflectBalances[account] > 0) {
            _balances[account] = tokenFromReflection(_reflectBalances[account]);
        }
        _isExcludedFromReward[account] = true;
        _excludedFromReward.push(account);
    }

    function includeInReward(address account) external onlyOwner {
        require(_isExcludedFromReward[account], "Account is not excluded");
        for (uint256 i = 0; i < _excludedFromReward.length; i++) {
            if (_excludedFromReward[i] == account) {
                _excludedFromReward[i] = _excludedFromReward[_excludedFromReward.length - 1];
                _balances[account] = 0;
                _isExcludedFromReward[account] = false;
                _excludedFromReward.pop();
                break;
            }
        }
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
}
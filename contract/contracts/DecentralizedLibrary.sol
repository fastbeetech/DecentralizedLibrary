// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DecentralizedLibrary {
    /// @notice Public Variable to track all the hashes(cids) that has been uploaded to library
    /// @dev Variable is an array of strings
    string[] public allUploadedFiles;
    /// @notice Public Variable to track the addresses that has uploaded files to Library
    /// @dev Variable is an array of addresses
    address[] public upLoaders;
    /// @notice Public Variable to track the uploaded hashes of the metadata of files uploaded by an address
    /// @dev Variable is an array of strings. Each upload generates a string and that string is stored in an array and passed into this variable
    mapping(address => string[]) public _uploadedCIDS;

    event Upload(string message);
    event SubsequentUpload(string message);

    /// @notice Upload a file as a first-time user of the Library
    /// @dev Update the mapping based on the address calling the function with the array of uploaded hashes
    /// @param _cidsToUpload The Array list of hashes to upload to IPFS
    function _upload(string[] memory _cidsToUpload) public {
        _uploadedCIDS[msg.sender] = _cidsToUpload;
        upLoaders.push(msg.sender);
        for (uint256 i = 0; i < _cidsToUpload.length; i += 1) {
            allUploadedFiles.push(_cidsToUpload[i]);
        } //push all the new files to the allUploadedFiles array

        emit Upload("You have just uploaded your first file");
    }

    /// @notice Upload a file as an existing user of the Library
    /// @dev Update the mapping based on the address calling the function with the array of uploaded hashes
    /// @dev Call the _addTwoArrays to add the new list of hashes to the existing list
    /// @param _newCidsToUpload The Array list of hashes to upload to IPFS
    function _subsequentUpload(string[] memory _newCidsToUpload) public {
        string[] memory _updatedCIDS;
        _updatedCIDS = _addTwoArrays(msg.sender, _newCidsToUpload); //helper function 1
        _uploadedCIDS[msg.sender] = _updatedCIDS;
        for (uint256 i = 0; i < _newCidsToUpload.length; i += 1) {
            allUploadedFiles.push(_newCidsToUpload[i]);
        } //push all the new files to the allUploadedFiles array

        emit SubsequentUpload("You have uploaded another file");
    }

    /// @notice Get a list of all uploaded hashes from the Library
    /// @dev view function to return an array of strings representing the hashes of all uploaded files in the Library
    /// @return An array of strings, representing the uploaded hashes of metadata files to IPFS
    function _getListOfAllUploadedCIDS() public view returns (string[] memory) {
        return allUploadedFiles;
    }

    /// @notice Get a list of uploaded hashes from the Library for a particular address
    /// @dev view function to return an array of strings representing the hashes of uploaded files for a particular address
    /// @param _address The address to check for it's uploaded files
    /// @return An array of strings, representing the uploaded hashes of metadata files to IPFS
    function _getListOfUploadedCIDS(address _address)
        public
        view
        returns (string[] memory)
    {
        return _uploadedCIDS[_address];
    }

    //HELPER FUNCTIONS
    //HELPER FUNCTIONS
    //HELPER FUNCTIONS

    /// @notice Adds two arrays of strings together when uploading a file
    /// @dev Retrieve the array of existing hashes and add to it, the elements of another similar array
    /// @dev This is tailored for uploading and subsequent uploads
    /// @param _address The address to check for it's existing hashes
    /// @param _newCidsToUpload The new set of hashes to add to the existing
    /// @return An array of strings, representing the total hashes of existing and new hashes
    function _addTwoArrays(address _address, string[] memory _newCidsToUpload)
        public
        returns (string[] memory)
    {
        string[] storage _updatedCIDS = _uploadedCIDS[_address]; //create an array that references the existing one in the mapping
        for (uint8 i = 0; i < _newCidsToUpload.length; i += 1) {
            _updatedCIDS.push(_newCidsToUpload[i]); //add the items from the new one to the old one
        }
        return _updatedCIDS; //final array is updated
    }


    /// @notice Get balance of address calling function
    /// @return ether balance of the wallet calling the function
    function viewBalance() public view returns (uint256) {
        return address(msg.sender).balance;
    }

    /// @notice Check if an address is an existing user of the Library
    /// @dev confirm if address is in the User Array
    /// @param _address The address to check if it's an existing user
    /// @return boolean, whether an address is existing in the Users Array
    function isAnUploader(address _address) public view returns (bool) {
        for (uint8 s = 0; s < upLoaders.length; s += 1) {
            if (_address == upLoaders[s]) return (true);
        }
        return (false);
    }
}

//required functions
//1. allow a customer to upload
//2. return an array of all the items uploaded by a customer
//3. return an array of all items inside the library
//4. return the balance of the address calling the upload/subsequent upload function
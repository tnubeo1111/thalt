alphabet = [
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
    't', 'u', 'v', 'w', 'x', 'y', 'z'
]

# The function checks whether the input condition is true or not
def check_terms():
    if direction != "encode" and direction != "decode":
        print('Please choose "encode" or "decode"')

# Paragraph encoding function
def caesar(start_text, shift_amount, start_direction):
    end_text = ""
    for letter in start_text:
        if letter in alphabet:
            position = alphabet.index(letter)
            if start_direction == "encode":
                new_position = position + shift_amount
            elif start_direction == "decode":
                new_position = position - shift_amount
            new_letter = alphabet[new_position]
            end_text += new_letter
        else:
            end_text += letter
    print(f"The {start_direction} text is {end_text}")

# Import and print the logo from art.py when the program starts.
from art import logo
print(logo)

# Can you figure out a way to ask the user if they want to restart the cipher program?
# e.g. Type 'yes' if you want to go again. Otherwise type 'no'.
# If they type 'yes' then ask them for the direction/text/shift again and call the caesar() function again?
# Hint: Try creating a while loop that continues to execute the program if the user types 'yes'.

should_continue = True
while should_continue:
    direction = input("Type 'encode' to encrypt, type 'decode' to decrypt:\n")
    text = input("Type your message:\n").lower()
    shift = int(input("Type the shift number:\n"))
  
# Try running the program and entering a shift number of 45.
# Add some code so that the program continues to work even if the user enters a shift number greater than 26.
    shift = shift % 26

    check_terms()
    caesar(start_text=text, shift_amount=shift, start_direction=direction)

    result = input(
        "Type 'yes' if you want to again. Type 'no' if you want to stop.\n")
    if result == "no":
        should_continue = False
        print("GoodBye ^!^")

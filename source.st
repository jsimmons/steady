pi : float = 3.14158265;

do_stuff : void () = {
    
}

find_area : float (r : float) = {
    return pi * r * r;
}

main : int (args : u8[][]) = {
    name := args[0];

    if(name == "a.out")
    {
        print("Interesting question about equality");
    }
    else
    {
        print("It actually hasn't gone away");
    }

    print(name);
    
    area := find_area(12.1);
}


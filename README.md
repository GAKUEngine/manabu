⚙学 Manabu Client for GAKU Engine
=================================
The Manabu client is built to access the GAKU Engine API.

Usage
=====


Testing
=======
Testing requires a working Docker installation with docker-compose accessble by your user account. 
You can run rspec directly and a container will be brought up on port 9000. Each time you run 
rspec the container is brought up and down, so each run will take some time. You can save time 
when running specs often by bringing up the test container in advance with 
```rake testing:container:up``` and waiting for about 10 seconds for the container to come up 
before running specs.

Testing Container Details
-------------------------
Test server:
 * URL: localhost
 * Port: 9000
 * HTTPS/SSL: No/Disabled

Test admin user:
 * username: admin
 * password: 123456

License & Contribution
======================
Manabu is Copyright 2012 K.K. GenSouSha of Aichi, Japan  
All rights reserved.

This software is dual licensed under the GNU GPL version 3 and the AGPL version 3.  
The full text of these licenses can be found here:  
[GPL](https://gnu.org/licenses/gpl.html) [AGPL](https://gnu.org/licenses/agpl.html)  

When submitting code, patches, or pull requests to official GAKU Engine repositories you agree to 
transfer copyright to your code to the GAKU Engine project. This is to prevent an external party 
from controlling code incorporated into GAKU Engine in such a way as to influence the development 
or sub-licensing of GAKU Engine. 

Alternative licenses can be granted upon consultation.  
Please contact info@gakuengine.com for details.

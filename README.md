# EP284U Ethical Hackning, Project Assignment
> Attacking logging server from logging client

This project describes a comprehensive attack chain that starts with a client computer monitored by
the Elastic Stack and culminates in the compromise of confidential data on the Elasticsearch server.
By strategically combining two relatively low-severity vulnerabilities, the project demonstrates how
their exploitation together poses a significantly greater threat. This project includes a demonstration
environment and includes an example attack script designed to exploit vulnerabilities within this setup,
providing a practical insight into these vulnerabilities.

Read more in the [report](Lucas-Drufva-EP284U-v2.1.pdf)


## Demo

Start the demo environment by running `vagrant up`
*Note this can take 5 minutes*

Execute the exploit by running `vagrant exploit`
*Note this can take 15 minutes*

![](./demo.gif)
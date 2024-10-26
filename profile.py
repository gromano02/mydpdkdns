"""
mydpdkndns setup
Instructions:
Wait for the profile instance to start, then click on the node in the topology and choose the `shell` menu item. 
"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Add two raw PCs to the request.
node1 = request.RawPC("node1")
node2 = request.RawPC("node2")

# Connect the two nodes.
link = request.Link("link")
link.addInterface(node1.addInterface("eth1"))
link.addInterface(node2.addInterface("eth1"))

# Install and execute a script on both nodes that is contained in the repository.
node1.addService(pg.Execute(shell="sh", command="/local/repository/setup.sh"))
node2.addService(pg.Execute(shell="sh", command="/local/repository/setup2.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
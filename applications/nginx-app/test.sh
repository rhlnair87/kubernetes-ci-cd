sleep 5
if curl localhost | grep -q 'Rahul '; then
   echo "Tests passed!"
   exit 0
else
   echo "Tests failed!"
   exit 1
fi

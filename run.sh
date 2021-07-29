PYLIBSPATH=pylibs

for dir in $PYLIBSPATH/*/
do
    dir=${dir%*/}
    export PYTHONPATH=$PYTHONPATH:$PYLIBSPATH/$dir
done

qmlscene %U qml/Main.qml

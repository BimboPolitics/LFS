Personally im building KDE plasma 5 for my desktop so im using this space to add notes about problems i ran into and what i did to fix them.

After installing QT and following the instructions for setup run "source /etc/profile.d/qt5.sh" the book doesnt say this but you should do it.



When installing Aspell it tells you to install a dictionary. US english speakers want this one. https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2020.12.07-0.tar.bz2

Untar it, cd into it then follow the install instructions in the book.

After fully installing KDE plasma 5 i had to hit ctrl+shift+f2 for the desktop to show. The full install time was around 4 days for compiling all dependencies. 

When building ostree a dependency for flatpack you will have to install fuse 2 from blfs 8 http://www.linuxfromscratch.org/blfs/view/8.3/postlfs/fuse2.html

Another pain in the ass dependency was libstemmer. Ill explain how i tricked that one in. Ive already installed rpm from source and the libstemmer/snowball source has zero install instructions smugly assuming you know what to do with a pile of compiled binaries and libraries puked into weird folders in the directory the code came in.

So i hunted down the source rpm for libstemmer and did an rpm rebuild of it, it failed of course but it put out the resulting libaries and binaries into the folder structures it would have installed them into eventually in the rpm build folders. So i coped them to where they wanted to go. Im going to turn into the joker.

Appstream, another dependency for flatpack is installed like this.

mkdir build
cd build
meson -Dqt=true ..
ninja
ninja install

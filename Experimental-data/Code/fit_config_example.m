%% data
% Fitting against wall
mov=VideoReader('config2_1_1.avi');
data = config8exp3;
roix=(295:333)+2;
roiy=(240:309)-20-62*1;


Nf=mov.NumberOfFrames;
Nx0=mov.Height;
Ny0=mov.Width;

%% Set parameters
x0=31;  %0
y0=0;  %32
mx=1000;  %1200
K=50;   %30
phi=0;  %0.8
mn=600;   % min pixel value in unstressed particle 1600

plotit=false; % show fit progress


%% save results
X=zeros(Nf,5);

%% loop
X0=[mx K phi,x0, y0];
for nf=90:Nf
%% Load Image
    im=double(read(mov,nf));
    im=squeeze(sum(sum(reshape(im(:,:,2),4,Nx0/4,4,Ny0/4),1),3));
    %% isolate particle np: [S]ingle [P]article [I]mage (SPI)
    im=im(roix,roiy);
    [Nx Ny]=size(im);
    if(mean(im(:))>200)
% create mask for SPI
        [yy xx]=ndgrid(1:Nx,1:Ny);
        cr=xx+1i*yy;
        mask=1;  % circle mask
        rp=xx+1i*yy;
        fprintf('%d: ',nf);
        X(nf,:)=fminsearchbnd(@(x) fchi07(x,mn,im,rp,mask,plotit),X0);
        X0=X(nf,:);

        fchi07(X0,mn,im,rp,mask,true);
    end
end

%% plot
time = (1:Nf);
F=abs(X(1:end,2));
ii=F>0;
%%
yyaxis left
plot(time(ii), abs(X(ii, 2))*6.9784/678.875, 'Linewidth', 3)
xlabel('Time [s]')
ylabel('Force [N]')
yyaxis right

plot(data(1:end, 1), data(1:end, 3), 'Linewidth', 3)
%legend
ylabel('Input Force [N]')
set(gca, 'Fontsize', 12)

%%
figure
plot(data(4503-200:50:end, 3), abs(X(ii, 2))*6.85/945.5, 'Linewidth', 3)
xlabel('Input Force [N]')
ylabel('Output Force [N]')

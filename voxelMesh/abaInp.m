function nodeOutCell = abaInp(fileName, abaData)
% build the main Abaqus .inp file
% input fileName:   file name of the inp file
% input abaData:    abaData structure (detail see manual)

% fileName = 'printInpTemp';
fid=fopen(sprintf('%s.inp',fileName),'wW');
% ------------------------------------------------------------------------
% Print Heading
headingKWs = [...
    '*Heading\n'...
    '*Preprint, echo=NO, model=NO, history=NO, contact=NO\n'...
    ];
fprintf(fid, headingKWs);
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');

% Print Part
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, '**\n');
fprintf(fid, '** PARTS\n');
fprintf(fid, '**\n');
for ii=1: size(abaData.Parts,2)
    fprintf(fid, [...
    '**\n'...
    '*Part, name=%s\n'...
    '*End Part\n'...
    '**\n'...
    ], abaData.Parts{ii});
end
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');
fprintf(fid, [...
    '**\n'...
    '** ASSEMBLY\n'...
    '**\n'...
    '*Assembly, name=Assembly\n'...
    '**\n'...
    ]);

% include the nodes and elements in different files
fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',abaData.Bone.MAT.matName));
abaInpPart(abaData.Bone);
fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',abaData.Screw.MAT.matName));
abaInpPart(abaData.Screw);

% Print Sets for BC and output
% nodeS = abaInpSet(fid, abaData.Bone, abaData.Screw);
nodeOutCell = abaInpSetTetScrew(fid, abaData.Bone, abaData.Screw);

fprintf(fid,'*End Assembly\n');
fprintf(fid, '** \n');
fprintf(fid, '** ----------------------------------------------------------------\n');

% Print Element controls
abaInpEleCon(fid, abaData.Bone);
abaInpEleCon(fid, abaData.Screw);

% Print Amplitudes
abaInpAmp(fid);

% Include Material properties (CDP): matCDP.inp
% abaInpMatCDP(fid, abaData.Bone.MAT);
fNCDP = 'matCDP';
fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNCDP));
abaInpMatCDP(abaData.Bone.MAT, fNCDP);

% Include Material properties (Linear Elastic): matLE.inp
fNLE = 'matLE';
fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNLE));
abaInpMatLE(abaData.Screw.MAT, fNLE);

% Include interactions: interFric.inp
fNinter = 'interFric';
fprintf(fid,sprintf('*INCLUDE, INPUT=%s.inp\n',fNinter));
abaInpInteraction(abaData.fricCoeef, fNinter);

% Print Step
abaInpStep(fid, abaData.mSFactor);

% Print Boundary conditions (BC)
abaInpBC(fid, abaData.displacement);

% Print Outputs
abaInpOutReq(fid);

fclose(fid);
disp('Check the inp file!');
end
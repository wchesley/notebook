using Cqrs.Application.Common;
using MediatR;

namespace Cqrs.Application.FeatureName.Commands.CleanArchitectureUseCase;

public record CleanArchitectureUseCaseCommand : IRequest<object>
{
}

public class CleanArchitectureUseCaseCommandHandler : IRequestHandler<CleanArchitectureUseCaseCommand, object>
{
    private readonly IWANDDbContext _context;

    public CleanArchitectureUseCaseCommandHandler(IWANDDbContext context)
    {
        _context = context;
    }

    public async Task<object> Handle(CleanArchitectureUseCaseCommand request, CancellationToken cancellationToken)
    {
        throw new NotImplementedException();
    }
}
